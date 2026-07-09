import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mova/services/photo_service.dart';
import 'package:mova/shared/models/tool_models.dart';
import 'package:path/path.dart' as path;
import 'package:photo_manager/photo_manager.dart';

void main() {
  test('pickAssets maps recent assets into media files', () async {
    final tempDir = await Directory.systemTemp.createTemp('mova_photo_service_');
    final imageFile = File(path.join(tempDir.path, 'shot.jpg'))
      ..writeAsStringSync('image');
    final videoFile = File(path.join(tempDir.path, 'clip.mp4'))
      ..writeAsStringSync('video');

    final service = PhotoService(
      requestPermission: () async => PermissionState.authorized,
      loadAssetPaths: () async => [
        AssetPathEntity(id: 'recent', name: 'Recent', isAll: true),
      ],
      loadAssetsFromPath: (_) async => [
        AssetEntity(
          id: 'asset-1',
          typeInt: AssetType.image.index,
          width: 1200,
          height: 800,
          title: 'shot.jpg',
        ),
        AssetEntity(
          id: 'asset-2',
          typeInt: AssetType.video.index,
          width: 1920,
          height: 1080,
          duration: 12,
          title: 'clip.mp4',
        ),
      ],
      fileForAsset: (asset) async => asset.id == 'asset-1' ? imageFile : videoFile,
      sizeForAsset: (asset) async => asset.id == 'asset-1' ? 5 : 9,
    );

    final result = await service.pickAssets();

    expect(result, hasLength(2));
    expect(result.first.displayName, 'shot.jpg');
    expect(result.first.path, imageFile.path);
    expect(result.first.kind, MediaKind.image);
    expect(result.first.source, InputSource.photoLibrary);
    expect(result.first.width, 1200);
    expect(result.first.height, 800);
    expect(result.first.sizeBytes, 5);
    expect(result.last.kind, MediaKind.video);
    expect(result.last.duration, const Duration(seconds: 12));
    expect(result.last.sizeBytes, 9);

    await tempDir.delete(recursive: true);
  });

  test('pickAssets throws readable error when photo access is denied', () async {
    final service = PhotoService(
      requestPermission: () async => PermissionState.denied,
    );

    await expectLater(
      service.pickAssets(),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('没有相册访问权限'),
        ),
      ),
    );
  });

  test('pickAssets throws readable error when no usable assets exist', () async {
    final service = PhotoService(
      requestPermission: () async => PermissionState.authorized,
      loadAssetPaths: () async => [
        AssetPathEntity(id: 'recent', name: 'Recent', isAll: true),
      ],
      loadAssetsFromPath: (_) async => const [],
    );

    await expectLater(
      service.pickAssets(),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('未找到可用'),
        ),
      ),
    );
  });
}
