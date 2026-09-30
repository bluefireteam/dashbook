import 'package:dashbook/src/widgets/dashbook_icon.dart';
import 'package:dashbook/src/widgets/helpers.dart';
import 'package:material_ui/material_ui.dart';

class DualThemeIcon extends StatelessWidget {
  const new({required this.isDarkTheme, required this.onChanged, super.key});

  final bool isDarkTheme;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DashbookIcon(
      tooltip: isDarkTheme ? 'Change to light theme' : 'Change to dark theme',
      icon: isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny,
      onPressed: () => onChanged(!isDarkTheme),
    );
  }
}

class MultiThemeIcon extends StatelessWidget {
  const new({
    required this.themeNames,
    required this.currentTheme,
    required this.onChanged,
    super.key,
  });

  final List<String> themeNames;
  final String? currentTheme;
  final ValueChanged<String> onChanged;

  Future<void> _chooseTheme(BuildContext context) async {
    final theme = await showPopup<String>(
      context: context,
      builder: (_) => _ThemeChooserDialog(
        themeNames: themeNames,
        currentTheme: currentTheme,
      ),
    );
    if (theme != null) {
      onChanged(theme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashbookIcon(
      tooltip: 'Choose theme',
      icon: Icons.palette,
      onPressed: () => _chooseTheme(context),
    );
  }
}

class _ThemeChooserDialog extends StatelessWidget {
  const new({required this.themeNames, required this.currentTheme});

  final List<String> themeNames;
  final String? currentTheme;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Theme chooser'),
      content: DropdownButton<String>(
        value: currentTheme,
        items: [
          for (final name in themeNames)
            DropdownMenuItem(value: name, child: Text(name)),
        ],
        onChanged: (name) => Navigator.of(context).pop(name),
      ),
    );
  }
}
