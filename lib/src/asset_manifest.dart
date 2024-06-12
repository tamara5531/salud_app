// ignore: unused_import
import 'dart:convert';

import 'package:flutter/services.dart';


Future<Map<String, List<String>>> _loadAssetManifest() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  return json.decode(manifestContent) as Map<String, List<String>>;
}



class AssetManifest {
  json() {}
}
