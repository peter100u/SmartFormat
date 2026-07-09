import 'package:mova/services/command_builder.dart';
import 'package:mova/shared/models/media_file.dart';
import 'package:mova/shared/models/task_models.dart';
import 'package:mova/shared/models/tool_models.dart';
import 'package:test/test.dart';

void main() {
  const builder = CommandBuilder();

  test('build creates a playable mp4 convert command for video.convert', () {
    final command = builder.build(
      _request(
        toolId: 'video.convert',
        outputPath: '/tmp/output.mp4',
        parameters: const {'quality': 'balanced'},
      ),
    );

    expect(command, [
      '-hide_banner',
      '-y',
      '-i',
      '/tmp/input.mov',
      '-map_metadata',
      '-1',
      '-movflags',
      '+faststart',
      '-pix_fmt',
      'yuv420p',
      '-c:v',
      'mpeg4',
      '-qscale:v',
      '2',
      '-c:a',
      'aac',
      '-b:a',
      '160k',
      '/tmp/output.mp4',
    ]);
  });

  test('build creates a smaller mp4 command for video.compress', () {
    final command = builder.build(
      _request(
        toolId: 'video.compress',
        outputPath: '/tmp/output.mp4',
        parameters: const {'quality': 'balanced'},
      ),
    );

    expect(
      command,
      containsAllInOrder([
        '-hide_banner',
        '-y',
        '-i',
        '/tmp/input.mov',
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
        '/tmp/output.mp4',
      ]),
    );
  });

  test('build strips video stream for video.extractAudio', () {
    final command = builder.build(
      _request(
        toolId: 'video.extractAudio',
        outputPath: '/tmp/output.mp3',
        parameters: const {'audioBitrate': '192k'},
      ),
    );

    expect(command, [
      '-hide_banner',
      '-y',
      '-i',
      '/tmp/input.mov',
      '-vn',
      '-map_metadata',
      '-1',
      '-c:a',
      'mp3',
      '-b:a',
      '192k',
      '-ar',
      '44100',
      '-ac',
      '2',
      '/tmp/output.mp3',
    ]);
  });

  test('build creates audio convert and compress commands', () {
    final convertCommand = builder.build(
      _request(
        toolId: 'audio.convert',
        outputPath: '/tmp/output.mp3',
        parameters: const {'audioBitrate': '192k'},
        inputKind: MediaKind.audio,
        inputPath: '/tmp/input.wav',
      ),
    );
    final compressCommand = builder.build(
      _request(
        toolId: 'audio.compress',
        outputPath: '/tmp/output.mp3',
        parameters: const {'audioBitrate': '128k'},
        inputKind: MediaKind.audio,
        inputPath: '/tmp/input.wav',
      ),
    );

    expect(
      convertCommand,
      containsAllInOrder([
        '-i',
        '/tmp/input.wav',
        '-vn',
        '-c:a',
        'mp3',
        '-b:a',
        '192k',
        '/tmp/output.mp3',
      ]),
    );
    expect(
      compressCommand,
      containsAllInOrder([
        '-i',
        '/tmp/input.wav',
        '-vn',
        '-c:a',
        'mp3',
        '-b:a',
        '128k',
        '/tmp/output.mp3',
      ]),
    );
  });

  test('build creates image convert and compress commands', () {
    final convertCommand = builder.build(
      _request(
        toolId: 'image.convert',
        outputPath: '/tmp/output.jpg',
        parameters: const {'quality': 90},
        inputKind: MediaKind.image,
        inputPath: '/tmp/input.png',
      ),
    );
    final compressCommand = builder.build(
      _request(
        toolId: 'image.compress',
        outputPath: '/tmp/output.jpg',
        parameters: const {'quality': 80},
        inputKind: MediaKind.image,
        inputPath: '/tmp/input.png',
      ),
    );

    expect(
      convertCommand,
      containsAllInOrder([
        '-i',
        '/tmp/input.png',
        '-frames:v',
        '1',
        '-q:v',
        '2',
        '/tmp/output.jpg',
      ]),
    );
    expect(
      compressCommand,
      containsAllInOrder([
        '-i',
        '/tmp/input.png',
        '-frames:v',
        '1',
        '-q:v',
        '6',
        '/tmp/output.jpg',
      ]),
    );
  });

  test('build creates heic to jpg command with explicit pixel format', () {
    final command = builder.build(
      _request(
        toolId: 'image.heicToJpg',
        outputPath: '/tmp/output.jpg',
        parameters: const {'quality': 92},
        inputKind: MediaKind.image,
        inputPath: '/tmp/input.heic',
      ),
    );

    expect(
      command,
      containsAllInOrder([
        '-hide_banner',
        '-y',
        '-i',
        '/tmp/input.heic',
        '-frames:v',
        '1',
        '-pix_fmt',
        'yuvj420p',
        '-q:v',
        '2',
        '/tmp/output.jpg',
      ]),
    );
  });
}

TaskRequest _request({
  required String toolId,
  required String outputPath,
  required Map<String, Object?> parameters,
  MediaKind inputKind = MediaKind.video,
  String inputPath = '/tmp/input.mov',
}) {
  return TaskRequest(
    id: 'task-1',
    toolId: toolId,
    input: MediaFile(
      id: 'file-1',
      displayName: inputPath.split('/').last,
      path: inputPath,
      kind: inputKind,
      source: InputSource.filePicker,
    ),
    presetId: 'preset-1',
    outputTarget: OutputTarget.appResult,
    outputPath: outputPath,
    parameters: parameters,
    createdAt: DateTime(2026, 1, 1),
  );
}
