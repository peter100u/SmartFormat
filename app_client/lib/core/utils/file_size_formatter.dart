String formatFileSize(int? bytes) {
  if (bytes == null) {
    return '未知大小';
  }
  if (bytes < 1024) {
    return '$bytes B';
  }
  final kb = bytes / 1024;
  if (kb < 1024) {
    return '${kb.toStringAsFixed(1)} KB';
  }
  final mb = kb / 1024;
  if (mb < 1024) {
    return '${mb.toStringAsFixed(1)} MB';
  }
  final gb = mb / 1024;
  return '${gb.toStringAsFixed(1)} GB';
}
