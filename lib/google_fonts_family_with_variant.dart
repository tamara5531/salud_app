import 'google_fonts_variant.dart';

class GoogleFontsFamilyWithVariant {
  final String family;
  final GoogleFontsVariant googleFontsVariant;

  GoogleFontsFamilyWithVariant({
    required this.family,
    required this.googleFontsVariant,
  });

  String toApiFilenamePrefix() {
    return '${family}_${googleFontsVariant.toApiFilename()}';
  }

  @override
  String toString() {
    return '$family:${googleFontsVariant.toString()}';
    // ignore: dead_code
  }
}
