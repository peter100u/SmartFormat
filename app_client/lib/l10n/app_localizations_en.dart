// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mova';

  @override
  String get navHome => 'Home';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Feedback';

  @override
  String get settingsFeedbackSubtitle => 'Send questions and suggestions';

  @override
  String get settingsPrivacyAndLegal => 'Privacy & Legal';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsUserAgreement => 'User Agreement';

  @override
  String get settingsLicense => 'License';

  @override
  String get settingsLicenseSubtitle =>
      'Open-source components and FFmpegKit disclosure';

  @override
  String get settingsStorage => 'Storage';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsAppVersion => 'App Version';

  @override
  String get settingsAboutMova => 'About Mova';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutMovaDescription =>
      'Mova is a modern media converter built for everyday users.';

  @override
  String get appVersionLabel => 'Version';

  @override
  String get appBuildNumberLabel => 'Build';

  @override
  String get appPackageNameLabel => 'Package';

  @override
  String get feedbackUnavailableMessage => 'No available mail app was found.';

  @override
  String get legalUnavailableMessage =>
      'Unable to open the placeholder link right now.';

  @override
  String get cacheClearConfirmTitle => 'Clear Cache';

  @override
  String get cacheClearConfirmMessage =>
      'This will remove temporary files and cache, but keep task history.';

  @override
  String get cacheClearConfirmAction => 'Clear';

  @override
  String get cacheClearCancelledAction => 'Cancel';

  @override
  String cacheClearSuccessMessage(Object size) {
    return 'Cleared $size of cache.';
  }

  @override
  String get cacheClearErrorMessage => 'Unable to clear cache right now.';

  @override
  String get routeErrorTitle => 'Page Not Found';

  @override
  String get routeErrorMessage => 'Unable to open this page right now.';

  @override
  String get webViewRefreshTooltip => 'Refresh';

  @override
  String get webViewLoadFailedTitle => 'Failed to load page';

  @override
  String get webViewRetryAction => 'Retry';

  @override
  String get webViewBackAction => 'Back';

  @override
  String get webViewForwardAction => 'Forward';

  @override
  String get webViewBlockedDomainMessage =>
      'This link is not in the trusted domain list.';

  @override
  String get webViewExternalOpenFailedMessage =>
      'Unable to open the external link.';
}
