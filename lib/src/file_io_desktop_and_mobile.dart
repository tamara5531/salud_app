import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

Future<ByteData?> loadFontFromDeviceFileSystem(String fontName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fontName';
    final file = File(filePath);

    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      return ByteData.view(Uint8List.fromList(bytes).buffer);
    } else {
      return null;
    }
  } catch (e) {
    print('Error loading font from file system: $e');
    return null;
  }
}

Future<void> saveFontToDeviceFileSystem(String fontName, Uint8List bytes) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fontName';
    final file = File(filePath);

    await file.writeAsBytes(bytes);
  } catch (e) {
    print('Error saving font to file system: $e');
  }
}
