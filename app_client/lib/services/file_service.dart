import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

import '../shared/models/media_file.dart';
import '../shared/models/tool_models.dart';

/// 封装系统文件选择器，并将平台文件句柄映射为 `MediaFile`。
///
/// 边界：
/// - 工具 controller 应通过这个服务获取输入文件。
/// - Widget 不应直接调用 `file_picker`。
/// - iOS/Android 的路径、沙箱和安全作用域访问差异应在这里处理。
class FileService {
  const FileService({this.pickFilesRequest, this.idGenerator, this.mimeResolver});

  final Future<FilePickerResult?> Function()? pickFilesRequest;
  final String Function()? idGenerator;
  final String? Function(String path)? mimeResolver;

  Future<List<MediaFile>> pickFiles() async {
    final result = await _pickFilesResult();
    if (result == null) {
      return const [];
    }

    final files = result.files
        .map(_mapFile)
        .whereType<MediaFile>()
        .toList(growable: false);
    if (files.isEmpty && result.files.isNotEmpty) {
      throw Exception('所选文件暂不支持，请改用本地媒体文件重试。');
    }
    return files;
  }

  Future<FilePickerResult?> _pickFilesResult() async {
    try {
      return await (pickFilesRequest ??
          () => FilePicker.pickFiles(
                type: FileType.media,
              ))();
    } catch (_) {
      throw Exception('选择文件失败，请重试。');
    }
  }

  MediaFile? _mapFile(PlatformFile file) {
    final path = file.path;
    if (path == null || path.isEmpty) {
      return null;
    }

    final kind = _resolveKind(path, file.name);
    if (kind == null) {
      return null;
    }

    return MediaFile(
      id: (idGenerator ?? _defaultIdGenerator)(),
      displayName: file.name,
      path: path,
      kind: kind,
      source: InputSource.filePicker,
      sizeBytes: file.size,
      mimeType: (mimeResolver ?? lookupMimeType)(path) ??
          (mimeResolver ?? lookupMimeType)(file.name),
    );
  }

  MediaKind? _resolveKind(String path, String name) {
    final mimeType =
        (mimeResolver ?? lookupMimeType)(path) ?? (mimeResolver ?? lookupMimeType)(name);
    if (mimeType == null) {
      return null;
    }
    if (mimeType.startsWith('video/')) {
      return MediaKind.video;
    }
    if (mimeType.startsWith('audio/')) {
      return MediaKind.audio;
    }
    if (mimeType.startsWith('image/')) {
      return MediaKind.image;
    }
    return null;
  }

  String _defaultIdGenerator() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
