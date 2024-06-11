// lib/src/google_fonts_base.dart

import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide AssetManifest;
import 'package:http/http.dart' as http;

import 'src/asset_manifest.dart' as google_fonts;
import 'file_io.dart' // Stubbed implementation by default.
    if (dart.library.io) 'file_io_desktop_and_mobile.dart' as file_io;
import 'google_fonts_descriptor.dart';
import 'google_fonts_family_with_variant.dart';
import 'google_fonts_variant.dart';

// Keep track of the fonts that are loaded or currently loading in FontLoader
// for the life of the app instance. Once a font is attempted to load, it does
// not need to be attempted to load again, unless the attempted load resulted
// in an error.
final Set<String> _loadedFonts = {};

@visibleForTesting
http.Client httpClient = http.Client();

@visibleForTesting
google_fonts.AssetManifest assetManifest = google_fonts.AssetManifest();

@visibleForTesting
void clearCache() => _loadedFonts.clear();
