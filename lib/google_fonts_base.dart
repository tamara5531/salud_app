import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide AssetManifest;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'file_io.dart' if (dart.library.io) 'file_io_desktop_and_mobile.dart' as file_io;
import 'google_fonts_descriptor.dart';
import 'google_fonts_family_with_variant.dart';
import 'google_fonts_variant.dart';

// Usa un alias para evitar conflictos
//import 'src/asset_manifest.dart' as google_fonts;

// Mantener registro de las fuentes cargadas o actualmente cargando en FontLoader
final Set<String> _loadedFonts = {};

@visibleForTesting
http.Client httpClient = http.Client();

@visibleForTesting
google_fonts.AssetManifest assetManifest = google_fonts.AssetManifest();

@visibleForTesting
void clearCache() => _loadedFonts.clear();

Future<TextStyle> googleFontsTextStyle({
  required String fontFamily,
  TextStyle? textStyle,
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  required Map<GoogleFontsVariant, GoogleFontsFile> fonts,
}) async {
  textStyle ??= const TextStyle();
  textStyle = textStyle.copyWith(
    color: color,
    backgroundColor: backgroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    height: height,
    locale: locale,
    foreground: foreground,
    background: background,
    shadows: shadows,
    fontFeatures: fontFeatures,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  );

  final variant = GoogleFontsVariant(
    fontWeight: textStyle.fontWeight ?? FontWeight.w400,
    fontStyle: textStyle.fontStyle ?? FontStyle.normal,
  );
  final matchedVariant = _closestMatch(variant, fonts.keys);
  final familyWithVariant = GoogleFontsFamilyWithVariant(
    family: fontFamily,
    googleFontsVariant: matchedVariant,
  );

  final descriptor = GoogleFontsDescriptor(
    familyWithVariant: familyWithVariant,
    file: fonts[matchedVariant]!,
  );

  await loadFontIfNecessary(descriptor);

  return textStyle.copyWith(
    fontFamily: familyWithVariant.toString(),
    fontFamilyFallback: [fontFamily],
  );
}

Future<void> loadFontIfNecessary(GoogleFontsDescriptor descriptor) async {
  final familyWithVariantString = descriptor.familyWithVariant.toString();
  final fontName = descriptor.familyWithVariant.toApiFilenamePrefix();

  if (_loadedFonts.contains(familyWithVariantString)) {
    return;
  } else {
    _loadedFonts.add(familyWithVariantString);
  }

  try {
    Future<ByteData?>? byteData;

    final assetManifestJson = await assetManifest.json();
    final assetPath = _findFamilyWithVariantAssetPath(
      descriptor.familyWithVariant,
      assetManifestJson,
    );
    if (assetPath != null) {
      byteData = rootBundle.load(assetPath);
    }
    if (await byteData != null) {
      return loadFontByteData(familyWithVariantString, byteData);
    }

    byteData = file_io.loadFontFromDeviceFileSystem(familyWithVariantString);

    if (await byteData != null) {
      return loadFontByteData(familyWithVariantString, byteData);
    }

    if (GoogleFonts.config.allowRuntimeFetching) {
      byteData = _httpFetchFontAndSaveToDevice(
        familyWithVariantString,
        descriptor.file,
      );
      if (await byteData != null) {
        return loadFontByteData(familyWithVariantString, byteData);
      }
    } else {
      throw Exception(
        'GoogleFonts.config.allowRuntimeFetching is false but font $fontName was not '
        'found in the application assets. Ensure $fontName.otf exists in a '
        "folder that is included in your pubspec's assets.",
      );
    }
  } catch (e) {
    _loadedFonts.remove(familyWithVariantString);
    print('Error: google_fonts was unable to load font $fontName because the '
        'following exception occurred:\n$e');
  }
}

@visibleForTesting
Future<void> loadFontByteData(
  String familyWithVariantString,
  Future<ByteData?>? byteData,
) async {
  if (byteData == null) return;
  final fontData = await byteData;
  if (fontData == null) return;

  final fontLoader = FontLoader(familyWithVariantString);
  fontLoader.addFont(Future.value(fontData));
  await fontLoader.load();
}

GoogleFontsVariant _closestMatch(
  GoogleFontsVariant sourceVariant,
  Iterable<GoogleFontsVariant> variantsToCompare,
) {
  int? bestScore;
  late GoogleFontsVariant bestMatch;
  for (final variantToCompare in variantsToCompare) {
    final score = _computeMatch(sourceVariant, variantToCompare);
    if (bestScore == null || score < bestScore) {
      bestScore = score;
      bestMatch = variantToCompare;
    }
  }
  return bestMatch;
}

Future<ByteData> _httpFetchFontAndSaveToDevice(
  String fontName,
  GoogleFontsFile file,
) async {
  final uri = Uri.tryParse(file.url);
  if (uri == null) {
    throw Exception('Invalid fontUrl: ${file.url}');
  }

  http.Response response;
  try {
    response = await httpClient.get(uri);
  } catch (e) {
    throw Exception('Failed to load font with url: ${file.url}');
  }
  if (response.statusCode == 200) {
    if (!_isFileSecure(file, response.bodyBytes)) {
      throw Exception(
        'File from ${file.url} did not match expected length and checksum.',
      );
    }

    _unawaited(
        file_io.saveFontToDeviceFileSystem(fontName, response.bodyBytes));

    return ByteData.view(response.bodyBytes.buffer);
  } else {
    throw Exception('Failed to load font with url: ${file.url}');
  }
}

int _computeMatch(GoogleFontsVariant a, GoogleFontsVariant b) {
  if (a == b) {
    return 0;
  }
  int score = (a.fontWeight.index - b.fontWeight.index).abs();
  if (a.fontStyle != b.fontStyle) {
    score += 2;
  }
  return score;
}

String? _findFamilyWithVariantAssetPath(
  GoogleFontsFamilyWithVariant familyWithVariant,
  Map<String, List<String>>? manifestJson,
) {
  if (manifestJson == null) return null;

  final apiFilenamePrefix = familyWithVariant.toApiFilenamePrefix();

  for (final assetList in manifestJson.values) {
    for (final String asset in assetList) {
      for (final matchingSuffix in ['.ttf', '.otf'].where(asset.endsWith)) {
        final assetWithoutExtension =
            asset.substring(0, asset.length - matchingSuffix.length);
        if (assetWithoutExtension.endsWith(apiFilenamePrefix)) {
          return asset;
        }
      }
    }
  }

  return null;
}

bool _isFileSecure(GoogleFontsFile file, Uint8List bytes) {
  final actualFileLength = bytes.length;
  final actualFileHash = sha256.convert(bytes).toString();
  return file.expectedLength == actualFileLength &&
      file.expectedFileHash == actualFileHash;
}

void _unawaited(Future<void> future) {}
