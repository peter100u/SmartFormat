import 'package:flutter_test/flutter_test.dart';
import 'package:mova/shared/models/tool_models.dart';
import 'package:mova/shared/tool_registry/mvp_tools.dart';
import 'package:mova/shared/tool_registry/tool_registry.dart';

void main() {
  test('registers all MVP media tools and groups them by category', () {
    final registry = ToolRegistry(mvpTools);

    expect(registry.all, hasLength(8));
    expect(registry.byCategory(MediaKind.video).map((tool) => tool.id), [
      'video.convert',
      'video.compress',
      'video.extractAudio',
    ]);
    expect(registry.byCategory(MediaKind.audio).map((tool) => tool.id), [
      'audio.convert',
      'audio.compress',
    ]);
    expect(registry.byCategory(MediaKind.image).map((tool) => tool.id), [
      'image.convert',
      'image.compress',
      'image.heicToJpg',
    ]);
  });

  test('throws a clear error when a tool id is unknown', () {
    final registry = ToolRegistry(mvpTools);

    expect(
      () => registry.requireById('missing.tool'),
      throwsA(isA<ArgumentError>()),
    );
  });
}
