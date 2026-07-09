import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 表示一次缓存清理操作移除的总字节数。
class CacheCleanupResult {
  const CacheCleanupResult({required this.bytesRemoved});

  final int bytesRemoved;
}

/// 清理应用临时目录和缓存目录中的可删除文件。
///
/// 边界：
/// - 只处理应用内部缓存和临时文件，不删除任务记录等持久化数据。
/// - 文件系统访问和平台目录差异应封装在这里。
class CacheService {
  const CacheService();

  Future<CacheCleanupResult> clearCache() async {
    var bytesRemoved = 0;

    final directories = <Directory?>[
      await getTemporaryDirectory(),
      await getApplicationCacheDirectorySafe(),
    ];

    for (final directory in directories) {
      if (directory == null || !await directory.exists()) {
        continue;
      }
      bytesRemoved += await _clearDirectory(directory);
    }

    return CacheCleanupResult(bytesRemoved: bytesRemoved);
  }

  Future<int> _clearDirectory(Directory directory) async {
    var bytesRemoved = 0;

    await for (final entity in directory.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        try {
          bytesRemoved += await entity.length();
          await entity.delete();
        } on FileSystemException {
          // 跳过无法删除的文件，并继续清理其余内容。
        }
      }
    }

    return bytesRemoved;
  }
}

/// 安全获取应用缓存目录；不支持时返回 `null`。
Future<Directory?> getApplicationCacheDirectorySafe() async {
  try {
    return getApplicationCacheDirectory();
  } on UnsupportedError {
    return null;
  }
}
