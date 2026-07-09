import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:photo_manager/photo_manager.dart';

import '../shared/models/media_file.dart';
import '../shared/models/tool_models.dart';

/// 封装相册输入，并规范化选中的媒体资源。
///
/// 边界：
/// - 工具 controller 通过这个服务导入相册中的图片或视频。
/// - 权限弹窗和平台资源导出差异应在 widget 外处理。
/// - 返回的文件应可被本地处理流水线直接读取。
class PhotoService {
  const PhotoService({
    this.requestPermission,
    this.loadAssetPaths,
    this.loadAssetsFromPath,
    this.fileForAsset,
    this.sizeForAsset,
  });

  final Future<PermissionState> Function()? requestPermission;
  final Future<List<AssetPathEntity>> Function()? loadAssetPaths;
  final Future<List<AssetEntity>> Function(AssetPathEntity path)? loadAssetsFromPath;
  final Future<File?> Function(AssetEntity asset)? fileForAsset;
  final Future<int> Function(AssetEntity asset)? sizeForAsset;

  Future<List<MediaFile>> pickAssets() async {
    final permissionState = await _requestPermission();
    if (!permissionState.hasAccess) {
      throw Exception('没有相册访问权限，请在系统设置中允许访问照片。');
    }

    final assetPaths = await _loadAssetPaths();
    if (assetPaths.isEmpty) {
      throw Exception('未找到可用的相册媒体。');
    }

    final assets = await _loadAssets(assetPaths.first);
    final files = <MediaFile>[];
    for (final asset in assets) {
      final file = await _readAssetFile(asset);
      if (file == null) {
        continue;
      }
      final kind = _mapKind(asset.type);
      if (kind == null) {
        continue;
      }
      files.add(
        MediaFile(
          id: asset.id,
          displayName: asset.title ?? path.basename(file.path),
          path: file.path,
          kind: kind,
          source: InputSource.photoLibrary,
          sizeBytes: await _readAssetSize(asset),
          duration: asset.type == AssetType.video
              ? Duration(seconds: asset.duration)
              : null,
          width: asset.width > 0 ? asset.width : null,
          height: asset.height > 0 ? asset.height : null,
          mimeType: asset.mimeType,
        ),
      );
    }

    if (files.isEmpty) {
      throw Exception('未找到可用的照片或视频文件。');
    }
    return files;
  }

  Future<PermissionState> _requestPermission() async {
    try {
      return await (requestPermission ?? PhotoManager.requestPermissionExtend)();
    } catch (_) {
      throw Exception('读取相册失败，请重试。');
    }
  }

  Future<List<AssetPathEntity>> _loadAssetPaths() async {
    try {
      return await (loadAssetPaths ??
          () => PhotoManager.getAssetPathList(
                hasAll: true,
                onlyAll: true,
                type: RequestType.common,
              ))();
    } catch (_) {
      throw Exception('读取相册失败，请重试。');
    }
  }

  Future<List<AssetEntity>> _loadAssets(AssetPathEntity assetPath) async {
    try {
      return await (loadAssetsFromPath ?? _defaultLoadAssetsFromPath)(assetPath);
    } catch (_) {
      throw Exception('读取相册失败，请重试。');
    }
  }

  Future<List<AssetEntity>> _defaultLoadAssetsFromPath(AssetPathEntity assetPath) {
    return assetPath.getAssetListPaged(page: 0, size: 100);
  }

  Future<File?> _readAssetFile(AssetEntity asset) async {
    try {
      return await (fileForAsset ?? (current) => current.file)(asset);
    } catch (_) {
      return null;
    }
  }

  Future<int?> _readAssetSize(AssetEntity asset) async {
    try {
      return await (sizeForAsset ?? (current) => current.fileSize)(asset);
    } catch (_) {
      return null;
    }
  }

  MediaKind? _mapKind(AssetType type) {
    switch (type) {
      case AssetType.image:
        return MediaKind.image;
      case AssetType.video:
        return MediaKind.video;
      case AssetType.audio:
        return MediaKind.audio;
      case AssetType.other:
        return null;
    }
  }
}
