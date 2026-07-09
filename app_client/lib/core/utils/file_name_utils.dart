import 'package:path/path.dart' as p;

String replaceExtension(String inputPath, String extension) {
  final normalized = extension.startsWith('.') ? extension : '.$extension';
  return p.setExtension(inputPath, normalized);
}

String displayNameFromPath(String inputPath) {
  return p.basename(inputPath);
}
