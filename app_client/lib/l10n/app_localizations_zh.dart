// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Mova';

  @override
  String get navHome => '首页';

  @override
  String get navTasks => '任务';

  @override
  String get navSettings => '设置';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsGeneral => '通用';

  @override
  String get settingsLanguage => '多语言';

  @override
  String get settingsSupport => '支持';

  @override
  String get settingsFeedback => '意见反馈';

  @override
  String get settingsFeedbackSubtitle => '发送问题和建议';

  @override
  String get settingsPrivacyAndLegal => '隐私与法律';

  @override
  String get settingsPrivacyPolicy => '隐私政策';

  @override
  String get settingsUserAgreement => '用户协议';

  @override
  String get settingsLicense => '许可证';

  @override
  String get settingsLicenseSubtitle => '开源组件、FFmpegKit 和第三方许可说明';

  @override
  String get settingsStorage => '存储';

  @override
  String get settingsClearCache => '清理缓存';

  @override
  String get settingsAboutSection => '关于';

  @override
  String get settingsAppVersion => 'App 版本';

  @override
  String get settingsAboutMova => '关于 Mova';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutMovaDescription => 'Mova 是一款面向普通用户的现代格式工厂。';

  @override
  String get appVersionLabel => '版本';

  @override
  String get appBuildNumberLabel => '构建号';

  @override
  String get appPackageNameLabel => '包名';

  @override
  String get feedbackUnavailableMessage => '暂时无法打开邮件应用。';

  @override
  String get legalUnavailableMessage => '暂时无法打开占位链接。';

  @override
  String get cacheClearConfirmTitle => '清理缓存';

  @override
  String get cacheClearConfirmMessage => '这会删除临时文件和缓存，但会保留任务记录。';

  @override
  String get cacheClearConfirmAction => '清理';

  @override
  String get cacheClearCancelledAction => '取消';

  @override
  String cacheClearSuccessMessage(Object size) {
    return '已清理 $size 缓存。';
  }

  @override
  String get cacheClearErrorMessage => '暂时无法清理缓存。';

  @override
  String get routeErrorTitle => '页面不存在';

  @override
  String get routeErrorMessage => '暂时无法打开这个页面。';

  @override
  String get webViewRefreshTooltip => '刷新';

  @override
  String get webViewLoadFailedTitle => '页面加载失败';

  @override
  String get webViewRetryAction => '重试';

  @override
  String get webViewBackAction => '后退';

  @override
  String get webViewForwardAction => '前进';

  @override
  String get webViewBlockedDomainMessage => '这个链接不在受信任域名列表中。';

  @override
  String get webViewExternalOpenFailedMessage => '暂时无法打开外部链接。';
}
