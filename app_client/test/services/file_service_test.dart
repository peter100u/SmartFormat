import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mova/services/file_service.dart';
import 'package:mova/shared/models/tool_models.dart';

void main() {
  test('pickFiles maps platform files into media files', () async {
    final service = FileService(
      pickFilesRequest: () async => FilePickerResult([
        PlatformFile(
          path: '/tmp/clip.mp4',
          name: 'clip.mp4',
          size: 42,
        ),
        PlatformFile(
          path: '/tmp/poster.png',
          name: 'poster.png',
          size: 7,
        ),
      ]),
      idGenerator: () => 'generated-id',
    );

    final result = await service.pickFiles();

    expect(result, hasLength(2));
    expect(result.first.displayName, 'clip.mp4');
    expect(result.first.path, '/tmp/clip.mp4');
    expect(result.first.kind, MediaKind.video);
    expect(result.first.source, InputSource.filePicker);
    expect(result.first.sizeBytes, 42);
    expect(result.last.kind, MediaKind.image);
  });

  test('pickFiles returns empty list when user cancels selection', () async {
    final service = FileService(pickFilesRequest: () async => null);

    final result = await service.pickFiles();

    expect(result, isEmpty);
  });

  test('pickFiles throws readable error when picker fails', () async {
    final service = FileService(
      pickFilesRequest: () => Future<FilePickerResult?>.error(Exception('boom')),
    );

    await expectLater(
      service.pickFiles(),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('选择文件失败'),
        ),
      ),
    );
  });
}
