import 'google_fonts_family_with_variant.dart';

class GoogleFontsDescriptor {
  final GoogleFontsFamilyWithVariant familyWithVariant;
  final GoogleFontsFile file;

  GoogleFontsDescriptor({
    required this.familyWithVariant,
    required this.file,
  });
}

class GoogleFontsFile {
  final String url;
  final int expectedLength;
  final String expectedFileHash;

  GoogleFontsFile({
    required this.url,
    required this.expectedLength,
    required this.expectedFileHash,
  });
}
