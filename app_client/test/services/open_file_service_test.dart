import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mova/services/open_file_service.dart';
import 'package:open_file/open_file.dart';

void main() {
  test('open throws readable error when file does not exist', () async {
    const service = OpenFileService();

    await expectLater(
      service.open('/tmp/does-not-exist.txt'),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('打开的文件不存在'),
        ),
      ),
    );
  });

  test('open succeeds when plugin returns done', () async {
    final tempDir = await Directory.systemTemp.createTemp('mova_open_service_');
    final file = File('${tempDir.path}/result.txt')..writeAsStringSync('done');
    String? openedPath;
    final service = OpenFileService(
      openFile: (path) async {
        openedPath = path;
        return OpenResult(type: ResultType.done, message: 'done');
      },
    );

    await service.open(file.path);

    expect(openedPath, file.path);

    await tempDir.delete(recursive: true);
  });

  test('open throws readable error when no app can handle the file', () async {
    final tempDir = await Directory.systemTemp.createTemp('mova_open_service_');
    final file = File('${tempDir.path}/result.txt')..writeAsStringSync('done');
    final service = OpenFileService(
      openFile: (_) async => OpenResult(
        type: ResultType.noAppToOpen,
        message: 'not found',
      ),
    );

    await expectLater(
      service.open(file.path),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('没有可用应用'),
        ),
      ),
    );

    await tempDir.delete(recursive: true);
  });
}
