import 'package:package_info_plus/package_info_plus.dart';

import '../core/constants/app_constants.dart';

/// 提供设置页和反馈诊断中展示的应用标识信息。
///
/// 边界：
/// - UI 应通过 provider 或 controller 读取这里的数据，不应硬编码构建信息。
/// - `package_info_plus` 的集成应放在这里。
class AppInfo {
  const AppInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
    required this.packageName,
  });

  final String appName;
  final String version;
  final String buildNumber;
  final String packageName;
}

/// 通过运行时包信息读取当前应用版本和包名。
class AppInfoService {
  const AppInfoService();

  Future<AppInfo> load() async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(
      appName: AppConstants.appName,
      version: info.version,
      buildNumber: info.buildNumber,
      packageName: info.packageName,
    );
  }
}
