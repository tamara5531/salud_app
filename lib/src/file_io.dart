import 'dart:typed_data';
// file_io.dart
export 'file_io_stub.dart' if (dart.library.io) 'file_io_desktop_and_mobile.dart';

Future<ByteData?> loadFontFromDeviceFileSystem(String familyWithVariantString) async {
  // Implementación por defecto o vacío si no se usa
  return null;
}

Future<void> saveFontToDeviceFileSystem(String fontName, Uint8List bytes) async {
  // Implementación por defecto o vacío si no se usa
}
