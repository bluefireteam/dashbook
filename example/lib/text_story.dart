import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';

void addTextStories(Dashbook dashbook) {
  dashbook
      .storiesOf('Text')
      .decorator(CenterDecorator())
      .add(
        'default',
        (ctx) {
          return Container(
            width: 300,
            padding: ctx.edgeInsetsProperty(
              'edge Insets',
              const EdgeInsets.fromLTRB(1, 2, 3, 4),
            ),
            child: Text(
              ctx.textProperty(
                'text',
                'Text Example',
                tooltipMessage: 'This property is used to change the content '
                    'from Text widget',
              ),
              textAlign: ctx.listProperty(
                'text align',
                TextAlign.center,
                TextAlign.values,
              ),
              textDirection: ctx.listProperty(
                'text direction',
                TextDirection.rtl,
                TextDirection.values,
              ),
              style: TextStyle(
                fontWeight: ctx.listProperty(
                  'font weight',
                  FontWeight.normal,
                  FontWeight.values,
                ),
                fontStyle: ctx.listProperty(
                  'font style',
                  FontStyle.normal,
                  FontStyle.values,
                ),
                fontSize: ctx.numberProperty('font size', 20),
                color: ctx.colorProperty(
                  'color',
                  Colors.red,
                ),
              ),
            ),
          );
        },
        codeLink:
            'https://github.com/erickzanardo/dashbook/blob/master/example/lib/main.dart',
        info: '''

## General information

Here could be some general information about this example, it could be any general information, maybe some instructions of any type of interactivity that this example could offer, or anything else that could be relevant to the user seeing this example about the `Text` widget.

Here even so cool code snippets could be used, just like the on below:

```
Text(
  "Text",
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

And now, here is some good old fashion lorem ipsum
   
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis dapibus diam pharetra tellus pulvinar malesuada. Etiam eget facilisis dui. Sed tincidunt luctus mauris, eu dictum neque pellentesque at. Proin maximus augue tempus turpis venenatis luctus. Curabitur sed felis velit. Quisque a feugiat urna, et tempus ipsum. Praesent maximus vel arcu ut tincidunt. Quisque ac lacus arcu. Nulla id tellus non urna condimentum sodales.

Suspendisse scelerisque, nisi eu convallis vestibulum, neque elit faucibus urna, a lacinia tellus ex at enim. Pellentesque quis mi tempus, fermentum justo vel, molestie est. Fusce ut luctus felis. In ullamcorper pharetra mauris a porta. Nullam varius turpis in iaculis maximus. Morbi porttitor imperdiet commodo. Duis auctor malesuada leo a viverra. Maecenas sed accumsan tortor. Maecenas ut enim lobortis metus tempus euismod quis at erat. Donec risus risus, facilisis at pharetra in, faucibus sed velit. Vestibulum semper dictum consequat. Quisque at leo sollicitudin, venenatis lorem vel, auctor odio. Mauris faucibus est et arcu pharetra, vel auctor sapien congue. Ut efficitur nec mi nec euismod. Integer in ipsum ac erat mollis porttitor. Aenean congue volutpat orci, ac ultrices turpis vulputate in.

Nulla sed quam sagittis, sagittis mauris quis, laoreet lacus. Donec condimentum, dui eget ornare venenatis, lectus neque ullamcorper sem, sed faucibus orci sapien sed metus. Mauris sapien nibh, luctus in odio id, semper porta neque. Pellentesque faucibus hendrerit tellus, at dictum erat mollis in. Pellentesque non massa quis neque tempor imperdiet sit amet auctor arcu. Curabitur molestie sem pulvinar enim pulvinar, vestibulum ornare orci scelerisque. Proin pharetra condimentum blandit. Aliquam ut odio nisi. Praesent rutrum, tortor sit amet sollicitudin imperdiet, orci nisl viverra nisl, hendrerit feugiat felis diam et dui. Mauris nec feugiat lacus. In accumsan bibendum congue.

Vestibulum accumsan magna et vestibulum varius. Aliquam erat volutpat. Quisque ornare lobortis ultricies. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean imperdiet, felis sed pulvinar egestas, libero enim dictum enim, et blandit enim leo sit amet nunc. Duis quis maximus ipsum. Pellentesque rutrum cursus felis, sed rhoncus massa viverra at. Nulla facilisi.

Morbi ornare est fringilla magna sodales porta. Proin nec orci commodo, fermentum velit at, luctus justo. In volutpat dictum eros. Donec lacus magna, ultricies vitae mattis vel, sodales mattis leo. Nullam pellentesque est in tortor eleifend, in volutpat nulla condimentum. Fusce ut lobortis metus, nec vestibulum diam. Duis laoreet vitae velit at porttitor. Etiam tincidunt cursus elit, eu malesuada sapien ultricies eu. Vivamus sem ex, pretium sit amet pharetra ut, cursus ornare leo. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris mattis purus eget cursus ultrices.

Pellentesque ac odio semper, tincidunt est a, consequat sapien. Ut convallis vehicula diam. Phasellus et elit vestibulum magna pharetra congue. Nullam orci mi, vulputate sed vestibulum vitae, fringilla quis massa. Nulla facilisi. Aliquam pharetra pretium congue. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi id pretium tellus. Morbi at justo consequat elit iaculis feugiat ut vitae nibh. Aenean quam lorem, mollis rutrum feugiat quis, gravida non velit. Aenean imperdiet eget mauris at molestie. Nunc nec mi at mi ultricies vehicula. Ut vitae enim luctus, ornare sapien vitae, eleifend mauris. Ut nec mauris non ex luctus fringilla non nec erat.

Nulla condimentum quam vel lobortis semper. Etiam odio mi, efficitur vel turpis dapibus, blandit fringilla dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nullam consectetur malesuada porttitor. Aenean luctus turpis ut arcu rhoncus vestibulum. Phasellus rhoncus elit tortor, consequat blandit ex consectetur eget. Nullam mollis tristique sollicitudin. Duis pellentesque vel sem eget feugiat. Suspendisse faucibus aliquet dolor, id volutpat sapien. Nulla lobortis sem arcu, nec dapibus sem pellentesque ac. Nulla ex tortor, suscipit rutrum lorem nec, convallis tempus metus. Nullam quis diam in tortor posuere pulvinar nec eget leo. Fusce mi turpis, tempor vitae massa placerat, tristique fringilla sem. Vivamus pharetra aliquam diam non posuere. Cras eget augue pellentesque, pretium ligula vel, porta nunc. Nulla magna felis, blandit sit amet finibus quis, fringilla volutpat lectus.

Proin sit amet euismod ligula. Phasellus consectetur venenatis ipsum, in dignissim metus dignissim eu. Vivamus vel tortor risus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras pharetra odio vel sem ullamcorper, nec fringilla mauris accumsan. Vivamus fermentum diam est, nec faucibus mauris porta ut. Curabitur quis magna enim.
''',
      )
      .add(
        'bold',
        (_) => const Text(
          'Text',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
      .add(
        'color text',
        (ctx) => Text(
          'Text',
          style: TextStyle(
            color: ctx.optionsProperty(
              'color',
              const Color(0xFF0000FF),
              [
                PropertyOption('Red', const Color(0xFFFF0000)),
                PropertyOption('Green', const Color(0xFF00FF00)),
                PropertyOption('Blue', const Color(0xFF0000FF)),
              ],
            ),
          ),
        ),
      );
}
