// File created by
// Lung Razvan <long1eu>
// on 22/08/2019

import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

String _platformPath(String name) {
  if (Platform.isLinux || Platform.isAndroid) {
    return 'ios/lib/lib' + name + '.so';
  }
  if (Platform.isMacOS) {
    return 'ios/lib/lib' + name + '.dylib';
  }
  if (Platform.isWindows) {
    return 'ios/lib/' + name + '.dll';
  }

  throw Exception('Platform not implemented');
}

ffi.DynamicLibrary dlopenPlatformSpecific(String name) {
  if (Platform.isIOS) return ffi.DynamicLibrary.process();
  final String fullPath = _platformPath(name);
  return ffi.DynamicLibrary.open(fullPath);
}
