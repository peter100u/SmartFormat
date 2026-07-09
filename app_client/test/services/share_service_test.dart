import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mova/services/share_service.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  test('shareFile throws readable error when file does not exist', () async {
    const service = ShareService();

    await expectLater(
      service.shareFile('/tmp/does-not-exist.txt'),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('分享的文件不存在'),
        ),
      ),
    );
  });

  test('shareFile shares existing file through share plus', () async {
    final tempDir = await Directory.systemTemp.createTemp('mova_share_service_');
    final file = File('${tempDir.path}/result.txt')..writeAsStringSync('done');
    List<XFile>? sharedFiles;
    final service = ShareService(
      shareFiles: (files) async {
        sharedFiles = files;
        return const ShareResult('ok', ShareResultStatus.success);
      },
    );

    await service.shareFile(file.path);

    expect(sharedFiles, isNotNull);
    expect(sharedFiles!.single.path, file.path);

    await tempDir.delete(recursive: true);
  });

  test('shareFile throws readable error when share sheet fails', () async {
    final tempDir = await Directory.systemTemp.createTemp('mova_share_service_');
    final file = File('${tempDir.path}/result.txt')..writeAsStringSync('done');
    final service = ShareService(
      shareFiles: (_) => Future<ShareResult>.error(Exception('boom')),
    );

    await expectLater(
      service.shareFile(file.path),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('分享文件失败'),
        ),
      ),
    );

    await tempDir.delete(recursive: true);
  });
}
