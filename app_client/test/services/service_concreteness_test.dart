import 'dart:io';

import 'package:hive_ce/hive_ce.dart';
import 'package:mova/core/constants/app_constants.dart';
import 'package:mova/services/app_info_service.dart';
import 'package:mova/services/cache_service.dart';
import 'package:mova/services/feedback_service.dart';
import 'package:mova/services/file_service.dart';
import 'package:mova/services/link_launcher_service.dart';
import 'package:mova/services/media_service.dart';
import 'package:mova/services/open_file_service.dart';
import 'package:mova/services/permission_service.dart';
import 'package:mova/services/photo_service.dart';
import 'package:mova/services/preferences_service.dart';
import 'package:mova/services/share_service.dart';
import 'package:test/test.dart';

void main() {
  test('services can be used as direct concrete classes', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'mova_service_concreteness_',
    );
    Hive.init(tempDir.path);
    final box = await Hive.openBox<String>(AppConstants.appPreferencesBoxName);

    try {
      expect(const AppInfoService(), isNotNull);
      expect(const CacheService(), isNotNull);
      expect(const FeedbackService(), isNotNull);
      expect(const FileService(), isNotNull);
      expect(const LinkLauncherService(), isNotNull);
      expect(const MediaService(), isNotNull);
      expect(const OpenFileService(), isNotNull);
      expect(const PermissionService(), isNotNull);
      expect(const PhotoService(), isNotNull);
      expect(PreferencesService(box), isNotNull);
      expect(const ShareService(), isNotNull);
    } finally {
      await box.close();
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}
