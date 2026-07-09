import 'package:hive_ce/hive_ce.dart';

/// 封装本地轻量偏好设置读写。
///
/// 边界：
/// - 仅负责持久化简单偏好项，不承载复杂业务状态。
/// - 具体存储实现细节应隐藏在 service 内部。
/// 使用 Hive 持久化应用内语言偏好。
class PreferencesService {
  PreferencesService([Box<String>? box]) : _box = box;

  static const _languageCodeKey = 'app.languageCode';
  final Box<String>? _box;

  Future<String?> loadLanguageCode() async {
    return _box?.get(_languageCodeKey);
  }

  Future<void> saveLanguageCode(String languageCode) async {
    final box = _box;
    if (box == null) {
      throw StateError('PreferencesService requires a Hive box.');
    }
    await box.put(_languageCodeKey, languageCode);
  }
}
