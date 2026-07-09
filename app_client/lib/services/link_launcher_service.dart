import 'package:url_launcher/url_launcher.dart';

/// 封装设置页占位法律链接的外部打开行为。
///
/// 边界：
/// - 页面或 controller 通过这个服务打开外部链接。
/// - `url_launcher` 的调用和外部跳转失败处理应收敛在这里。
/// 使用 `url_launcher` 以外部应用方式打开占位法律链接。
class LinkLauncherService {
  const LinkLauncherService();

  static final _placeholderLegalUri = Uri.parse('https://www.baidu.com');

  Future<void> openPlaceholderLegalUrl() async {
    if (!await launchUrl(
      _placeholderLegalUri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('legal_url_unavailable');
    }
  }
}
