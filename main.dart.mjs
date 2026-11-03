// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            AB: o => o instanceof RegExp,
      AC: o => o.buffer,
      AD: x0 => x0.state,
      AE: (x0,x1) => x0.appendChild(x1),
      AF: (x0,x1) => x0.removeAttribute(x1),
      AG: x0 => x0.type,
      AH: x0 => x0.innerWidth,
      AI: (x0,x1) => { x0.max = x1 },
      AJ: x0 => new window.ImageDecoder(x0),
      AK: (x0,x1) => x0.removeItem(x1),
      B: s => printToConsole(s),
      BB: o => o,
      BC: (b, o) => new DataView(b, o),
      BD: x0 => x0.hash,
      BE: x0 => x0.debugShowSemanticsNodes,
      BF: x0 => x0.isConnected,
      BG: x0 => x0.hasFocus(),
      BH: x0 => x0.width,
      BI: (x0,x1) => { x0.disabled = x1 },
      BJ: x0 => x0.name,
      BK: (x0,x1,x2) => x0.setItem(x1,x2),
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      CC: (b, o, l) => new DataView(b, o, l),
      CD: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      CE: (o, c) => o instanceof c,
      CF: x0 => x0.click(),
      CG: x0 => x0.shiftKey,
      CH: x0 => x0.clientWidth,
      CI: (x0,x1) => { x0.scrollLeft = x1 },
      CJ: x0 => x0.repetitionCount,
      CK: x0 => x0.length,
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: x0 => x0.dotAll,
      DC: Function.prototype.call.bind(DataView.prototype.getUint8),
      DD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      DE: x0 => x0.vendor,
      DF: (x0,x1) => x0.getElementsByClassName(x1),
      DG: x0 => x0.visibilityState,
      DH: (x0,x1) => x0.removeChild(x1),
      DI: (x0,x1) => { x0.spellcheck = x1 },
      DJ: x0 => x0.frameCount,
      DK: x0 => x0.getReader(),
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: x0 => x0.unicode,
      EC: Function.prototype.call.bind(DataView.prototype.setUint8),
      ED: x0 => x0.state,
      EE: (x0,x1) => x0.createTextNode(x1),
      EF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      EG: x0 => x0.disconnect(),
      EH: x0 => x0.firstChild,
      EI: (x0,x1) => { x0.disabled = x1 },
      EJ: x0 => x0.selectedTrack,
      EK: x0 => x0.value,
      F: () => new Error().stack,
      FB: x0 => x0.ignoreCase,
      FC: Function.prototype.call.bind(DataView.prototype.getFloat64),
      FD: (x0,x1,x2) => x0.addEventListener(x1,x2),
      FE: (x0,x1) => { x0.nonce = x1 },
      FF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      FG: x0 => new Intl.Locale(x0),
      FH: x0 => x0.viewConstraints,
      FI: (x0,x1) => x0.transferFromImageBitmap(x1),
      FJ: x0 => x0.completed,
      FK: x0 => x0.done,
      G: s => JSON.stringify(s),
      GB: x0 => x0.multiline,
      GC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      GD: (x0,x1) => x0.go(x1),
      GE: x0 => x0.nonce,
      GF: (x0,x1) => x0.contains(x1),
      GG: x0 => x0.region,
      GH: x0 => x0.hostElement,
      GI: (x0,x1) => x0.getContext(x1),
      GJ: x0 => x0.ready,
      GK: x0 => x0.read(),
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (o, p, r) => o.replace(p, () => r),
      HC: (t, s) => t.set(s),
      HD: (s) => +s,
      HE: () => globalThis.window.flutterConfiguration,
      HF: x0 => x0.target,
      HG: x0 => x0.script,
      HH: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      HI: (x0,x1) => { x0.height = x1 },
      HJ: x0 => x0.tracks,
      HK: x0 => x0.body,
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: s => s.toUpperCase(),
      IC: Function.prototype.call.bind(DataView.prototype.setFloat32),
      ID: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      IE: (x0,x1) => x0.attachShadow(x1),
      IF: (x0,x1) => x0.dispatchEvent(x1),
      IG: x0 => x0.language,
      IH: x0 => ({runApp: x0}),
      II: (x0,x1) => { x0.width = x1 },
      IJ: x0 => x0.close(),
      IK: (x0,x1) => new OffscreenCanvas(x0,x1),
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: Object.is,
      JC: Function.prototype.call.bind(DataView.prototype.getFloat32),
      JD: (x0,x1) => x0.append(x1),
      JE: x0 => x0.preventDefault(),
      JF: (x0,x1) => x0.createEvent(x1),
      JG: x0 => x0.languages,
      JH: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      JI: x0 => x0.height,
      JJ: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      JK: x0 => x0.assetBase,
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: (x0,x1) => x0.test(x1),
      KC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      KD: (x0,x1) => { x0.textContent = x1 },
      KE: (x0,x1) => x0.contains(x1),
      KF: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      KG: (x0,x1) => x0.observe(x1),
      KH: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      KI: x0 => x0.width,
      KJ: (x0,x1) => x0.decode(x1),
      KK: x0 => x0.loader,
      L: o => o === undefined,
      LB: (a, i, v) => a[i] = v,
      LC: Function.prototype.call.bind(DataView.prototype.getUint32),
      LD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      LE: (x0,x1) => x0.focus(x1),
      LF: () => globalThis.window,
      LG: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      LH: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      LI: x0 => x0.rasterEndMilliseconds,
      LJ: x0 => x0.displayHeight,
      LK: () => globalThis._flutter,
      M: o => String(o),
      MB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      MC: Function.prototype.call.bind(DataView.prototype.setUint32),
      MD: x0 => x0.parentElement,
      ME: (x0,x1) => x0.closest(x1),
      MF: x0 => x0.readText(),
      MG: x0 => new ResizeObserver(x0),
      MH: () => typeof dartUseDateNowForTicks !== "undefined",
      MI: x0 => x0.rasterStartMilliseconds,
      MJ: x0 => x0.displayWidth,
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      NC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      ND: (x0,x1) => x0.querySelectorAll(x1),
      NE: (x0,x1) => x0.getAttribute(x1),
      NF: x0 => x0.clipboard,
      NG: x0 => globalThis.parseFloat(x0),
      NH: () => Date.now(),
      NI: x0 => x0.imageBitmaps,
      NJ: x0 => x0.duration,
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: Function.prototype.call.bind(String.prototype.toLowerCase),
      OC: Function.prototype.call.bind(DataView.prototype.getInt32),
      OD: x0 => x0.length,
      OE: x0 => x0.activeElement,
      OF: (x0,x1) => x0.writeText(x1),
      OG: (x0,x1) => x0.getComputedStyle(x1),
      OH: () => 1000 * performance.now(),
      OI: x0 => x0.canvasKitMaximumSurfaces,
      OJ: x0 => x0.image,
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: (o, p, r) => o.replaceAll(p, () => r),
      PC: Function.prototype.call.bind(DataView.prototype.setInt32),
      PD: (x0,x1) => x0.item(x1),
      PE: (x0,x1) => x0.add(x1),
      PF: x0 => x0.unlock(),
      PG: x0 => x0.documentElement,
      PH: x0 => new Uint8Array(x0),
      PI: (a, i) => a.splice(i, 1),
      PJ: () => globalThis.window.ImageDecoder,
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: x0 => x0.length,
      QC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      QD: x0 => x0.userAgent,
      QE: x0 => x0.classList,
      QF: (x0,x1) => x0.lock(x1),
      QG: x0 => x0.computedStyleMap(),
      QH: (x0,x1,x2) => x0.slice(x1,x2),
      QI: a => a.pop(),
      QJ: x0 => x0.decode(),
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: x0 => x0.flags,
      RC: o => o instanceof Uint16Array,
      RD: x0 => x0.maxTouchPoints,
      RE: x0 => x0.data,
      RF: x0 => x0.orientation,
      RG: (x0,x1) => x0.get(x1),
      RH: (x0,x1) => x0.decode(x1),
      RI: (map, o) => map.get(o),
      RJ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: s => s.trim(),
      SC: Function.prototype.call.bind(DataView.prototype.getUint16),
      SD: x0 => x0.platform,
      SE: x0 => x0.scrollTop,
      SF: (x0,x1) => x0.querySelector(x1),
      SG: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      SH: (x0,x1) => x0.adoptText(x1),
      SI: () => new WeakMap(),
      SJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      T: x0 => new Promise(x0),
      TB: (a, s) => a.join(s),
      TC: Function.prototype.call.bind(DataView.prototype.setUint16),
      TD: x0 => x0.navigator,
      TE: (handle) => clearTimeout(handle),
      TF: (x0,x1) => { x0.content = x1 },
      TG: x0 => x0.matches,
      TH: x0 => x0.first(),
      TI: x0 => new WeakRef(x0),
      TJ: (x0,x1,x2) => x0.addEventListener(x1,x2),
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: x0 => x0.random(),
      UC: o => o instanceof Int16Array,
      UD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      UE: (x0,x1) => { x0.scrollTop = x1 },
      UF: x0 => x0.head,
      UG: (x0,x1) => x0.matchMedia(x1),
      UH: x0 => x0.next(),
      UI: x0 => x0.deref(),
      UJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: () => globalThis.Math,
      VC: Function.prototype.call.bind(DataView.prototype.getInt16),
      VD: Date.now,
      VE: x0 => x0.tagName,
      VF: (x0,x1) => { x0.name = x1 },
      VG: x0 => x0.matches,
      VH: x0 => x0.current(),
      VI: () => globalThis.WeakRef,
      VJ: x0 => x0.send(),
      W: x0 => new Array(x0),
      WB: (x0,x1) => x0.error(x1),
      WC: Function.prototype.call.bind(DataView.prototype.setInt16),
      WD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      WE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      WF: (x0,x1) => { x0.title = x1 },
      WG: x0 => x0.timeStamp,
      WH: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      WI: (map, o, v) => map.set(o, v),
      WJ: x0 => x0.status,
      X: o => [o],
      XB: () => globalThis.console,
      XC: o => o instanceof Uint8ClampedArray,
      XD: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      XE: (x0,x1) => { x0.value = x1 },
      XF: () => globalThis.document,
      XG: (x0,x1) => x0.hasAttribute(x1),
      XH: x0 => x0.v8BreakIterator,
      XI: x0 => x0.href,
      XJ: x0 => x0.response,
      Y: (o0, o1) => [o0, o1],
      YB: s => s.trimRight(),
      YC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      YD: x0 => x0.style,
      YE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      YF: (x0,x1) => x0.vibrate(x1),
      YG: x0 => x0.buttons,
      YH: () => globalThis.Intl,
      YI: x0 => x0.location,
      YJ: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: (a, i) => a.push(i),
      ZC: Function.prototype.call.bind(DataView.prototype.setInt8),
      ZD: (x0,x1) => x0.createElement(x1),
      ZE: (x0,x1) => { x0.value = x1 },
      ZF: (o, p) => p in o,
      ZG: x0 => x0.ctrlKey,
      ZH: (x0,x1) => x0.segment(x1),
      ZI: () => globalThis.window,
      ZJ: (x0,x1) => { x0.responseType = x1 },
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      aC: Function.prototype.call.bind(DataView.prototype.getInt8),
      aD: x0 => x0.body,
      aE: x0 => x0.relatedTarget,
      aF: x0 => x0.arrayBuffer(),
      aG: x0 => x0.y,
      aH: x0 => x0.index,
      aI: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      aJ: () => new XMLHttpRequest(),
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: () => ({}),
      bC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      bD: x0 => x0.remove(),
      bE: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      bF: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      bG: x0 => x0.x,
      bH: x0 => x0.next(),
      bI: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      bJ: x0 => x0.pop(),
      c: o => o,
      cB: (o, p, v) => o[p] = v,
      cC: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      cD: (x0,x1) => x0.getPropertyValue(x1),
      cE: x0 => x0.value,
      cF: x0 => x0.status,
      cG: x0 => x0.offsetTop,
      cH: x0 => x0.value,
      cI: x0 => x0.naturalHeight,
      cJ: x0 => x0.input,
      d: (o, p) => o[p],
      dB: () => [],
      dC: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      dD: (x0,x1) => x0.warn(x1),
      dE: x0 => x0.selectionDirection,
      dF: (x0,x1) => x0.fetch(x1),
      dG: x0 => x0.scrollLeft,
      dH: x0 => x0.done,
      dI: x0 => x0.naturalWidth,
      dJ: (o, p) => p in o,
      e: () => globalThis,
      eB: b => !!b,
      eC: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      eD: x0 => x0.console,
      eE: x0 => x0.selectionStart,
      eF: x0 => x0.content,
      eG: x0 => x0.offsetLeft,
      eH: (o, m, a) => o[m].apply(o, a),
      eI: (x0,x1) => x0.createElement(x1),
      eJ: x0 => x0.groups,
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: x0 => new Int8Array(x0),
      fC: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      fD: (x0,x1) => { x0.id = x1 },
      fE: x0 => x0.selectionEnd,
      fF: x0 => x0.document,
      fG: x0 => x0.offsetParent,
      fH: x0 => x0.iterator,
      fI: (x0,x1) => { x0.pointerEvents = x1 },
      fJ: () => globalThis.window.navigator.userAgent,
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      gC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      gD: (x0,x1) => x0.requestAnimationFrame(x1),
      gE: x0 => x0.value,
      gF: x0 => x0.language,
      gG: x0 => x0.deltaMode,
      gH: () => globalThis.Symbol,
      gI: (x0,x1) => { x0.height = x1 },
      gJ: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: x0 => new Uint8Array(x0),
      hC: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      hD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      hE: x0 => x0.selectionDirection,
      hF: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      hG: x0 => x0.deltaY,
      hH: (x0,x1) => new Intl.Segmenter(x0,x1),
      hI: (x0,x1) => { x0.width = x1 },
      hJ: (a, s, e) => a.slice(s, e),
      i: (string, token) => string.split(token),
      iB: x0 => new Uint8ClampedArray(x0),
      iC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      iD: x0 => x0.now(),
      iE: x0 => x0.selectionStart,
      iF: (x0,x1) => x0.prepend(x1),
      iG: x0 => x0.deltaX,
      iH: x0 => x0.Segmenter,
      iI: x0 => x0.style,
      iJ: x0 => x0.hash,
      j: o => o instanceof Array,
      jB: x0 => new Int16Array(x0),
      jC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      jD: x0 => x0.performance,
      jE: x0 => x0.selectionEnd,
      jF: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      jG: x0 => x0.wheelDeltaY,
      jH: x0 => x0.buffer,
      jI: (x0,x1) => { x0.src = x1 },
      jJ: x0 => x0.hostElement,
      k: (a, i) => a[i],
      kB: x0 => new Uint16Array(x0),
      kC: x0 => x0.history,
      kD: (x0,x1) => x0.unregister(x1),
      kE: x0 => x0.keyCode,
      kF: (x0,x1) => x0.querySelector(x1),
      kG: x0 => x0.wheelDeltaX,
      kH: x0 => x0.wasmMemory,
      kI: () => globalThis.document,
      kJ: x0 => x0.location,
      l: a => a.length,
      lB: x0 => new Int32Array(x0),
      lC: x0 => x0.search,
      lD: () => globalThis.window.FinalizationRegistry,
      lE: (x0,x1) => x0.scrollIntoView(x1),
      lF: (x0,x1) => x0.querySelectorAll(x1),
      lG: x0 => x0.key,
      lH: () => globalThis.window._flutter_skwasmInstance,
      lI: x0 => x0.nextSibling,
      lJ: (x0,x1) => x0.getModifierState(x1),
      m: (string, times) => string.repeat(times),
      mB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      mC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      mD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      mE: x0 => x0.multiViewEnabled,
      mF: x0 => x0.tabIndex,
      mG: x0 => x0.identifier,
      mH: () => new TextDecoder(),
      mI: (x0,x1) => x0.debug(x1),
      mJ: x0 => x0.metaKey,
      n: (decoder, codeUnits) => decoder.decode(codeUnits),
      nB: x0 => new Uint32Array(x0),
      nC: x0 => x0.location,
      nD: x0 => new window.FinalizationRegistry(x0),
      nE: x0 => x0.parent,
      nF: x0 => x0.parentNode,
      nG: x0 => x0.touches,
      nH: x0 => x0.debugSkipFontRetryDelay,
      nI: x0 => x0.src,
      nJ: x0 => x0.altKey,
      o: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      oB: x0 => new Float32Array(x0),
      oC: x0 => x0.pathname,
      oD: x0 => x0.scale,
      oE: (x0,x1) => x0.replaceWith(x1),
      oF: x0 => x0.clientY,
      oG: x0 => x0.pressure,
      oH: (x0,x1,x2) => x0.set(x1,x2),
      oI: (x0,x1) => x0.revokeObjectURL(x1),
      oJ: x0 => x0.ctrlKey,
      p: () => new TextDecoder("utf-8", {fatal: true}),
      pB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      pC: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      pD: x0 => x0.visualViewport,
      pE: (x0,x1) => { x0.type = x1 },
      pF: x0 => x0.clientX,
      pG: x0 => x0.tiltY,
      pH: x0 => x0.fontFallbackBaseUrl,
      pI: (x0,x1) => { x0.src = x1 },
      pJ: x0 => x0.isComposing,
      q: () => new TextDecoder("utf-8", {fatal: false}),
      qB: x0 => new Float64Array(x0),
      qC: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      qD: x0 => x0.devicePixelRatio,
      qE: (x0,x1) => { x0.className = x1 },
      qF: x0 => x0.getBoundingClientRect(),
      qG: x0 => x0.tiltX,
      qH: (handle) => clearInterval(handle),
      qI: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      qJ: x0 => x0.code,
      r: s => s.trimLeft(),
      rB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      rC: o => Object.keys(o),
      rD: (d, digits) => d.toFixed(digits),
      rE: (x0,x1) => { x0.tabIndex = x1 },
      rF: x0 => x0.bottom,
      rG: x0 => x0.pointerType,
      rH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      rI: x0 => x0.naturalHeight,
      rJ: x0 => x0.repeat,
      s: (l, r) => l === r,
      sB: x0 => new ArrayBuffer(x0),
      sC: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      sD: x0 => x0.maxHeight,
      sE: (x0,x1) => { x0.name = x1 },
      sF: x0 => x0.top,
      sG: x0 => x0.pointerId,
      sH: () => Date.now(),
      sI: x0 => x0.naturalWidth,
      sJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      t: (x0,x1) => x0[x1],
      tB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      tC: f => f.dartFunction,
      tD: x0 => x0.maxWidth,
      tE: (x0,x1) => { x0.placeholder = x1 },
      tF: x0 => x0.right,
      tG: x0 => x0.getCoalescedEvents(),
      tH: (x0,x1,x2) => x0.insertBefore(x1,x2),
      tI: x0 => x0.decode(),
      tJ: x0 => x0.userAgent,
      u: o => o,
      uB: (x0,x1,x2) => new DataView(x0,x1,x2),
      uC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      uD: x0 => x0.minHeight,
      uE: (x0,x1) => { x0.autocomplete = x1 },
      uF: x0 => x0.left,
      uG: (x0,x1) => x0.getModifierState(x1),
      uH: x0 => x0.id,
      uI: (x0,x1) => { x0.decoding = x1 },
      uJ: x0 => x0.navigator,
      v: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      vB: (o, p) => o[p],
      vC: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      vD: x0 => x0.minWidth,
      vE: (x0,x1) => { x0.name = x1 },
      vF: x0 => x0.clientY,
      vG: x0 => x0.blur(),
      vH: x0 => x0.offsetHeight,
      vI: (x0,x1) => { x0.crossOrigin = x1 },
      vJ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      w: x0 => x0.index,
      wB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      wC: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      wD: x0 => x0.height,
      wE: (x0,x1) => { x0.placeholder = x1 },
      wF: x0 => x0.clientX,
      wG: x0 => x0.button,
      wH: x0 => x0.offsetWidth,
      wI: (x0,x1) => x0.createObjectURL(x1),
      wJ: (x0,x1) => x0.getItem(x1),
      x: (x0,x1) => x0.exec(x1),
      xB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      xC: (o, i) => o[i],
      xD: x0 => x0.width,
      xE: (x0,x1) => { x0.action = x1 },
      xF: x0 => x0.changedTouches,
      xG: x0 => x0.innerHeight,
      xH: x0 => x0.stopPropagation(),
      xI: x0 => x0.URL,
      xJ: x0 => x0.localStorage,
      y: (x0,x1) => { x0.lastIndex = x1 },
      yB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      yC: o => o.length,
      yD: x0 => x0.screen,
      yE: (x0,x1) => { x0.method = x1 },
      yF: x0 => x0.offsetY,
      yG: x0 => x0.height,
      yH: x0 => x0.disabled,
      yI: x0 => new Blob(x0),
      yJ: (x0,x1) => x0.key(x1),
      z: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      zB: o => o.byteOffset,
      zC: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      zD: (x0,x1) => x0.removeProperty(x1),
      zE: (x0,x1) => { x0.noValidate = x1 },
      zF: x0 => x0.offsetX,
      zG: x0 => x0.clientHeight,
      zH: (x0,x1) => { x0.min = x1 },
      zI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      zJ: x0 => x0.length,

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
