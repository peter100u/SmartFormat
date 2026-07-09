import 'package:url_launcher/url_launcher.dart';

/// 通过选定渠道发送用户反馈和失败任务诊断信息。
///
/// 边界：
/// - 设置页和失败任务流程应通过 controller 调用这个服务。
/// - 邮件、应用拉起、插件调用等副作用应收敛在这里。
/// - 只能附带精简日志或错误摘要，不能附带原始用户媒体文件。
class FeedbackService {
  const FeedbackService();

  static const _supportEmail = 'support@peter100u.com';

  Future<void> sendFeedback({
    required String subject,
    required String body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {'subject': subject, 'body': body},
    );

    if (!await launchUrl(uri)) {
      throw Exception('feedback_unavailable');
    }
  }
}
