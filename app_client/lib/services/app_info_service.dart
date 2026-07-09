/// Provides app identity shown in Settings and feedback diagnostics.
///
/// Boundary:
/// - UI should read this through providers/controllers, not hard-code build data.
/// - package_info_plus integration belongs here.
class AppInfo {
  const AppInfo({
    required this.version,
    required this.buildNumber,
    required this.packageName,
  });

  final String version;
  final String buildNumber;
  final String packageName;
}

abstract class AppInfoService {
  Future<AppInfo> load();
}

class PendingAppInfoService implements AppInfoService {
  const PendingAppInfoService();

  @override
  Future<AppInfo> load() async {
    // TODO(mvp): Replace static values with package_info_plus runtime metadata.
    return const AppInfo(
      version: '1.0.0',
      buildNumber: '1',
      packageName: 'com.peter100u.mova',
    );
  }
}
