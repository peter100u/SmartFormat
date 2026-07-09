import 'tool_models.dart';

class MediaFile {
  const MediaFile({
    required this.id,
    required this.displayName,
    required this.kind,
    required this.source,
    this.path,
    this.mimeType,
    this.sizeBytes,
    this.duration,
    this.width,
    this.height,
  });

  final String id;
  final String displayName;
  final String? path;
  final String? mimeType;
  final MediaKind kind;
  final InputSource source;
  final int? sizeBytes;
  final Duration? duration;
  final int? width;
  final int? height;
}
