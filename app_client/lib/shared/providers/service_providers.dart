import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/app_info_service.dart';
import '../../services/command_builder.dart';
import '../../services/feedback_service.dart';
import '../../services/file_service.dart';
import '../../services/media_service.dart';
import '../../services/open_file_service.dart';
import '../../services/permission_service.dart';
import '../../services/photo_service.dart';
import '../../services/share_service.dart';
import '../../services/task_runner.dart';
import 'repository_providers.dart';

/// Declares service dependencies used by controllers and repositories.
///
/// Boundary:
/// - Providers compose dependencies; they should not grow business logic.
/// - Pending* services mark MVP integration gaps intentionally.
/// - Widgets should prefer controllers over reading these providers directly.
final commandBuilderProvider = Provider<CommandBuilder>((ref) {
  return const CommandBuilder();
});

final mediaServiceProvider = Provider<MediaService>((ref) {
  return const PendingMediaService();
});

final taskRunnerProvider = Provider<TaskRunner>((ref) {
  return TaskRunner(
    mediaService: ref.watch(mediaServiceProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    commandBuilder: ref.watch(commandBuilderProvider),
  );
});

final fileServiceProvider = Provider<FileService>((ref) {
  return const PendingFileService();
});

final photoServiceProvider = Provider<PhotoService>((ref) {
  return const PendingPhotoService();
});

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return const PendingPermissionService();
});

final shareServiceProvider = Provider<ShareService>((ref) {
  return const PendingShareService();
});

final openFileServiceProvider = Provider<OpenFileService>((ref) {
  return const PluginOpenFileService();
});

final appInfoServiceProvider = Provider<AppInfoService>((ref) {
  return const PendingAppInfoService();
});

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return const PendingFeedbackService();
});
