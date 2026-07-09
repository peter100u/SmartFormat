import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/app_info_service.dart';
import '../../services/cache_service.dart';
import '../../services/command_builder.dart';
import '../../services/feedback_service.dart';
import '../../services/file_service.dart';
import '../../services/link_launcher_service.dart';
import '../../services/media_service.dart';
import '../../services/open_file_service.dart';
import '../../services/permission_service.dart';
import '../../services/preferences_service.dart';
import '../../services/photo_service.dart';
import '../../services/share_service.dart';
import '../../services/task_runner.dart';
import 'database_providers.dart';
import 'logging_providers.dart';
import 'repository_providers.dart';

/// 声明 controller 和 repository 会使用到的 service 依赖。
///
/// 边界：
/// - Provider 只负责组装依赖，不应承载业务逻辑。
/// - 未接通的 MVP 能力仍通过具体 service 中的 TODO 和占位实现表达。
/// - Widget 应优先通过 controller 间接使用这些 provider，而不是直接读取。
final commandBuilderProvider = Provider<CommandBuilder>((ref) {
  return const CommandBuilder();
});

final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService(logger: ref.watch(loggerProvider));
});

final taskRunnerProvider = Provider<TaskRunner>((ref) {
  return TaskRunner(
    mediaService: ref.watch(mediaServiceProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    commandBuilder: ref.watch(commandBuilderProvider),
    logger: ref.watch(loggerProvider),
  );
});

final fileServiceProvider = Provider<FileService>((ref) {
  return const FileService();
});

final photoServiceProvider = Provider<PhotoService>((ref) {
  return const PhotoService();
});

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return const PermissionService();
});

final shareServiceProvider = Provider<ShareService>((ref) {
  return const ShareService();
});

final openFileServiceProvider = Provider<OpenFileService>((ref) {
  return const OpenFileService();
});

final appInfoServiceProvider = Provider<AppInfoService>((ref) {
  return const AppInfoService();
});

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return const FeedbackService();
});

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService(ref.watch(appPreferencesBoxProvider));
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  return const CacheService();
});

final linkLauncherServiceProvider = Provider<LinkLauncherService>((ref) {
  return const LinkLauncherService();
});
