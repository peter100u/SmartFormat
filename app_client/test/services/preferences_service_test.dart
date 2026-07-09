import 'dart:io';

import 'package:hive_ce/hive_ce.dart';
import 'package:mova/services/preferences_service.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late Box<String> box;
  late PreferencesService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mova_preferences_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>('app_preferences');
    service = PreferencesService(box);
  });

  tearDown(() async {
    await box.close();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saveLanguageCode persists the selected in-app language', () async {
    await service.saveLanguageCode('en');

    expect(await service.loadLanguageCode(), 'en');
  });

  test('saveLanguageCode overwrites the previous language selection', () async {
    await service.saveLanguageCode('zh');
    await service.saveLanguageCode('en');

    expect(await service.loadLanguageCode(), 'en');
  });
}
