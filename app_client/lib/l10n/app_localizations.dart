import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// 应用名称，显示在应用框架和标题位置。
  ///
  /// In zh, this message translates to:
  /// **'Mova'**
  String get appTitle;

  /// 底部导航中首页标签。
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get navHome;

  /// 底部导航中任务页标签。
  ///
  /// In zh, this message translates to:
  /// **'任务'**
  String get navTasks;

  /// 底部导航中设置页标签。
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get navSettings;

  /// 设置页标题。
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// 通用设置分组标题。
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get settingsGeneral;

  /// 语言设置入口标签。
  ///
  /// In zh, this message translates to:
  /// **'多语言'**
  String get settingsLanguage;

  /// 支持相关分组标题。
  ///
  /// In zh, this message translates to:
  /// **'支持'**
  String get settingsSupport;

  /// 反馈入口标签。
  ///
  /// In zh, this message translates to:
  /// **'意见反馈'**
  String get settingsFeedback;

  /// 反馈入口副标题。
  ///
  /// In zh, this message translates to:
  /// **'发送问题和建议'**
  String get settingsFeedbackSubtitle;

  /// 隐私与法律分组标题。
  ///
  /// In zh, this message translates to:
  /// **'隐私与法律'**
  String get settingsPrivacyAndLegal;

  /// 隐私政策页面入口标签。
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get settingsPrivacyPolicy;

  /// 用户协议页面入口标签。
  ///
  /// In zh, this message translates to:
  /// **'用户协议'**
  String get settingsUserAgreement;

  /// 许可证页面入口标签。
  ///
  /// In zh, this message translates to:
  /// **'许可证'**
  String get settingsLicense;

  /// 许可证入口副标题。
  ///
  /// In zh, this message translates to:
  /// **'开源组件、FFmpegKit 和第三方许可说明'**
  String get settingsLicenseSubtitle;

  /// 存储设置分组标题。
  ///
  /// In zh, this message translates to:
  /// **'存储'**
  String get settingsStorage;

  /// 清理缓存操作标签。
  ///
  /// In zh, this message translates to:
  /// **'清理缓存'**
  String get settingsClearCache;

  /// 关于应用分组标题。
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsAboutSection;

  /// 应用版本页面入口标签。
  ///
  /// In zh, this message translates to:
  /// **'App 版本'**
  String get settingsAppVersion;

  /// 关于 Mova 页面入口标签。
  ///
  /// In zh, this message translates to:
  /// **'关于 Mova'**
  String get settingsAboutMova;

  /// 中文语言选项标签。
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// 英文语言选项标签。
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// 关于 Mova 页面中的说明文本。
  ///
  /// In zh, this message translates to:
  /// **'Mova 是一款面向普通用户的现代格式工厂。'**
  String get aboutMovaDescription;

  /// 应用版本字段标签。
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get appVersionLabel;

  /// 应用构建号字段标签。
  ///
  /// In zh, this message translates to:
  /// **'构建号'**
  String get appBuildNumberLabel;

  /// 应用包名字段标签。
  ///
  /// In zh, this message translates to:
  /// **'包名'**
  String get appPackageNameLabel;

  /// 无法打开邮件应用时显示的提示。
  ///
  /// In zh, this message translates to:
  /// **'暂时无法打开邮件应用。'**
  String get feedbackUnavailableMessage;

  /// 无法打开法律相关占位链接时显示的提示。
  ///
  /// In zh, this message translates to:
  /// **'暂时无法打开占位链接。'**
  String get legalUnavailableMessage;

  /// 清理缓存确认弹窗标题。
  ///
  /// In zh, this message translates to:
  /// **'清理缓存'**
  String get cacheClearConfirmTitle;

  /// 清理缓存确认弹窗说明文本。
  ///
  /// In zh, this message translates to:
  /// **'这会删除临时文件和缓存，但会保留任务记录。'**
  String get cacheClearConfirmMessage;

  /// 确认清理缓存按钮标签。
  ///
  /// In zh, this message translates to:
  /// **'清理'**
  String get cacheClearConfirmAction;

  /// 取消清理缓存按钮标签。
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cacheClearCancelledAction;

  /// 清理缓存成功后显示的提示。
  ///
  /// In zh, this message translates to:
  /// **'已清理 {size} 缓存。'**
  String cacheClearSuccessMessage(String size);

  /// 清理缓存失败时显示的提示。
  ///
  /// In zh, this message translates to:
  /// **'暂时无法清理缓存。'**
  String get cacheClearErrorMessage;

  /// 路由兜底错误页标题。
  ///
  /// In zh, this message translates to:
  /// **'页面不存在'**
  String get routeErrorTitle;

  /// 路由兜底错误页说明文本。
  ///
  /// In zh, this message translates to:
  /// **'暂时无法打开这个页面。'**
  String get routeErrorMessage;

  /// 内嵌网页刷新按钮提示。
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get webViewRefreshTooltip;

  /// 内嵌网页加载失败时的标题。
  ///
  /// In zh, this message translates to:
  /// **'页面加载失败'**
  String get webViewLoadFailedTitle;

  /// 内嵌网页加载失败后的重试按钮标签。
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get webViewRetryAction;

  /// 内嵌网页后退按钮标签。
  ///
  /// In zh, this message translates to:
  /// **'后退'**
  String get webViewBackAction;

  /// 内嵌网页前进按钮标签。
  ///
  /// In zh, this message translates to:
  /// **'前进'**
  String get webViewForwardAction;

  /// 访问未受信任域名时显示的提示。
  ///
  /// In zh, this message translates to:
  /// **'这个链接不在受信任域名列表中。'**
  String get webViewBlockedDomainMessage;

  /// 无法打开外部链接时显示的提示。
  ///
  /// In zh, this message translates to:
  /// **'暂时无法打开外部链接。'**
  String get webViewExternalOpenFailedMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
