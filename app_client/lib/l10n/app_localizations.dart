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

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'Mova'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get navHome;

  /// No description provided for @navTasks.
  ///
  /// In zh, this message translates to:
  /// **'任务'**
  String get navTasks;

  /// No description provided for @navSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get navSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In zh, this message translates to:
  /// **'多语言'**
  String get settingsLanguage;

  /// No description provided for @settingsSupport.
  ///
  /// In zh, this message translates to:
  /// **'支持'**
  String get settingsSupport;

  /// No description provided for @settingsFeedback.
  ///
  /// In zh, this message translates to:
  /// **'意见反馈'**
  String get settingsFeedback;

  /// No description provided for @settingsFeedbackSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'发送问题和建议'**
  String get settingsFeedbackSubtitle;

  /// No description provided for @settingsPrivacyAndLegal.
  ///
  /// In zh, this message translates to:
  /// **'隐私与法律'**
  String get settingsPrivacyAndLegal;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsUserAgreement.
  ///
  /// In zh, this message translates to:
  /// **'用户协议'**
  String get settingsUserAgreement;

  /// No description provided for @settingsLicense.
  ///
  /// In zh, this message translates to:
  /// **'许可证'**
  String get settingsLicense;

  /// No description provided for @settingsLicenseSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'开源组件、FFmpegKit 和第三方许可说明'**
  String get settingsLicenseSubtitle;

  /// No description provided for @settingsStorage.
  ///
  /// In zh, this message translates to:
  /// **'存储'**
  String get settingsStorage;

  /// No description provided for @settingsClearCache.
  ///
  /// In zh, this message translates to:
  /// **'清理缓存'**
  String get settingsClearCache;

  /// No description provided for @settingsAboutSection.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsAboutSection;

  /// No description provided for @settingsAppVersion.
  ///
  /// In zh, this message translates to:
  /// **'App 版本'**
  String get settingsAppVersion;

  /// No description provided for @settingsAboutMova.
  ///
  /// In zh, this message translates to:
  /// **'关于 Mova'**
  String get settingsAboutMova;

  /// No description provided for @languageChinese.
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @aboutMovaDescription.
  ///
  /// In zh, this message translates to:
  /// **'Mova 是一款面向普通用户的现代格式工厂。'**
  String get aboutMovaDescription;

  /// No description provided for @appVersionLabel.
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get appVersionLabel;

  /// No description provided for @appBuildNumberLabel.
  ///
  /// In zh, this message translates to:
  /// **'构建号'**
  String get appBuildNumberLabel;

  /// No description provided for @appPackageNameLabel.
  ///
  /// In zh, this message translates to:
  /// **'包名'**
  String get appPackageNameLabel;

  /// No description provided for @feedbackUnavailableMessage.
  ///
  /// In zh, this message translates to:
  /// **'暂时无法打开邮件应用。'**
  String get feedbackUnavailableMessage;

  /// No description provided for @legalUnavailableMessage.
  ///
  /// In zh, this message translates to:
  /// **'暂时无法打开占位链接。'**
  String get legalUnavailableMessage;

  /// No description provided for @cacheClearConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'清理缓存'**
  String get cacheClearConfirmTitle;

  /// No description provided for @cacheClearConfirmMessage.
  ///
  /// In zh, this message translates to:
  /// **'这会删除临时文件和缓存，但会保留任务记录。'**
  String get cacheClearConfirmMessage;

  /// No description provided for @cacheClearConfirmAction.
  ///
  /// In zh, this message translates to:
  /// **'清理'**
  String get cacheClearConfirmAction;

  /// No description provided for @cacheClearCancelledAction.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cacheClearCancelledAction;

  /// No description provided for @cacheClearSuccessMessage.
  ///
  /// In zh, this message translates to:
  /// **'已清理 {size} 缓存。'**
  String cacheClearSuccessMessage(Object size);

  /// No description provided for @cacheClearErrorMessage.
  ///
  /// In zh, this message translates to:
  /// **'暂时无法清理缓存。'**
  String get cacheClearErrorMessage;

  /// No description provided for @routeErrorTitle.
  ///
  /// In zh, this message translates to:
  /// **'页面不存在'**
  String get routeErrorTitle;

  /// No description provided for @routeErrorMessage.
  ///
  /// In zh, this message translates to:
  /// **'暂时无法打开这个页面。'**
  String get routeErrorMessage;

  /// No description provided for @webViewRefreshTooltip.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get webViewRefreshTooltip;

  /// No description provided for @webViewLoadFailedTitle.
  ///
  /// In zh, this message translates to:
  /// **'页面加载失败'**
  String get webViewLoadFailedTitle;

  /// No description provided for @webViewRetryAction.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get webViewRetryAction;

  /// No description provided for @webViewBackAction.
  ///
  /// In zh, this message translates to:
  /// **'后退'**
  String get webViewBackAction;

  /// No description provided for @webViewForwardAction.
  ///
  /// In zh, this message translates to:
  /// **'前进'**
  String get webViewForwardAction;

  /// No description provided for @webViewBlockedDomainMessage.
  ///
  /// In zh, this message translates to:
  /// **'这个链接不在受信任域名列表中。'**
  String get webViewBlockedDomainMessage;

  /// No description provided for @webViewExternalOpenFailedMessage.
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
