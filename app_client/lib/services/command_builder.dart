import '../shared/models/task_models.dart';

/// 将任务请求和预设转换为 FFmpeg 命令参数。
///
/// 边界：
/// - 工具默认值应放在工具注册表或请求参数中。
/// - 这个构建器只负责把已校验的请求转换为命令。
/// - 它不应执行 FFmpeg、写入任务记录或展示 UI 错误。
class CommandBuilder {
  const CommandBuilder();

  List<String> build(TaskRequest request) {
    final inputPath = request.input.path;
    if (inputPath == null || inputPath.isEmpty) {
      throw StateError('TaskRequest.input.path 不能为空');
    }

    final prefix = ['-hide_banner', '-y', '-i', inputPath];
    return switch (request.toolId) {
      'video.convert' => [
        ...prefix,
        '-map_metadata',
        '-1',
        '-movflags',
        '+faststart',
        '-pix_fmt',
        'yuv420p',
        '-c:v',
        'mpeg4',
        '-qscale:v',
        _videoQScale(request.parameters['quality']),
        '-c:a',
        'aac',
        '-b:a',
        '160k',
        request.outputPath,
      ],
      'video.compress' => [
        ...prefix,
        '-map_metadata',
        '-1',
        '-vf',
        'scale=1280:-2:force_original_aspect_ratio=decrease',
        '-pix_fmt',
        'yuv420p',
        '-c:v',
        'mpeg4',
        '-qscale:v',
        '5',
        '-c:a',
        'aac',
        '-b:a',
        '128k',
        request.outputPath,
      ],
      'video.extractAudio' => [
        ...prefix,
        '-vn',
        '-map_metadata',
        '-1',
        '-c:a',
        _audioCodec(request.outputPath),
        '-b:a',
        _audioBitrate(request.parameters, fallback: '192k'),
        '-ar',
        '44100',
        '-ac',
        '2',
        request.outputPath,
      ],
      'audio.convert' => [
        ...prefix,
        '-vn',
        '-map_metadata',
        '-1',
        '-c:a',
        _audioCodec(request.outputPath),
        '-b:a',
        _audioBitrate(request.parameters, fallback: '192k'),
        '-ar',
        '44100',
        '-ac',
        '2',
        request.outputPath,
      ],
      'audio.compress' => [
        ...prefix,
        '-vn',
        '-map_metadata',
        '-1',
        '-c:a',
        _audioCodec(request.outputPath),
        '-b:a',
        _audioBitrate(request.parameters, fallback: '128k'),
        '-ar',
        '44100',
        '-ac',
        '2',
        request.outputPath,
      ],
      'image.convert' => [
        ...prefix,
        '-frames:v',
        '1',
        ..._imageQualityFlags(
          request.outputPath,
          request.parameters,
          fallbackQ: '2',
        ),
        request.outputPath,
      ],
      'image.compress' => [
        ...prefix,
        '-frames:v',
        '1',
        ..._imageQualityFlags(
          request.outputPath,
          request.parameters,
          fallbackQ: '6',
        ),
        request.outputPath,
      ],
      'image.heicToJpg' => [
        ...prefix,
        '-frames:v',
        '1',
        '-pix_fmt',
        'yuvj420p',
        '-q:v',
        _imageQScale(request.parameters, fallback: '2'),
        request.outputPath,
      ],
      _ => [...prefix, request.outputPath],
    };
  }

  String _audioBitrate(
    Map<String, Object?> parameters, {
    required String fallback,
  }) {
    final bitrate = parameters['audioBitrate']?.toString().trim();
    if (bitrate == null || bitrate.isEmpty) {
      return fallback;
    }
    return bitrate;
  }

  String _audioCodec(String outputPath) {
    final extension = outputPath.split('.').last.toLowerCase();
    return switch (extension) {
      'aac' || 'm4a' => 'aac',
      'wav' => 'pcm_s16le',
      _ => 'mp3',
    };
  }

  List<String> _imageQualityFlags(
    String outputPath,
    Map<String, Object?> parameters, {
    required String fallbackQ,
  }) {
    final extension = outputPath.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => ['-compression_level', _pngCompressionLevel(parameters)],
      _ => ['-q:v', _imageQScale(parameters, fallback: fallbackQ)],
    };
  }

  String _pngCompressionLevel(Map<String, Object?> parameters) {
    final quality = _parseInt(parameters['quality']);
    if (quality == null) {
      return '4';
    }
    if (quality >= 90) {
      return '3';
    }
    if (quality >= 80) {
      return '5';
    }
    return '7';
  }

  String _videoQScale(Object? quality) {
    final normalized = quality?.toString().trim();
    return switch (normalized) {
      'high' => '1',
      'balanced' => '2',
      'small' => '5',
      _ => '2',
    };
  }

  String _imageQScale(
    Map<String, Object?> parameters, {
    required String fallback,
  }) {
    final quality = _parseInt(parameters['quality']);
    if (quality == null) {
      return fallback;
    }
    if (quality >= 90) {
      return '2';
    }
    if (quality >= 85) {
      return '4';
    }
    return '6';
  }

  int? _parseInt(Object? value) {
    if (value == null) {
      return null;
    }
    return int.tryParse(value.toString());
  }
}
