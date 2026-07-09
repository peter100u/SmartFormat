import 'package:mova/services/media_service.dart';
import 'package:mova/shared/models/tool_models.dart';
import 'package:test/test.dart';

import '../support/log_test_helpers.dart';

void main() {
  test('probe maps backend snapshot into MediaProbeInfo', () async {
    final service = MediaService(
      backend: FakeFFmpegKitBackend(
        probeSnapshot: const MediaProbeSnapshot(
          duration: Duration(seconds: 12),
          width: 1920,
          height: 1080,
          bitrate: 3200000,
          videoCodec: 'h264',
          audioCodec: 'aac',
          hasVideo: true,
          hasAudio: true,
          rotation: 90,
        ),
      ),
    );

    final result = await service.probe('/tmp/input.mp4');

    expect(result.duration, const Duration(seconds: 12));
    expect(result.width, 1920);
    expect(result.height, 1080);
    expect(result.bitrate, 3200000);
    expect(result.videoCodec, 'h264');
    expect(result.audioCodec, 'aac');
    expect(result.hasVideo, isTrue);
    expect(result.hasAudio, isTrue);
    expect(result.rotation, 90);
  });

  test(
    'execute maps statistics and completion events into task progress',
    () async {
      final logOutput = RecordingLogOutput();
      final service = MediaService(
        backend: FakeFFmpegKitBackend(
          executionEvents: [
            const MediaExecutionEvent.statistics(
              progress: 0.35,
              elapsed: Duration(seconds: 3),
            ),
            const MediaExecutionEvent.completed(
              returnCode: 0,
              elapsed: Duration(seconds: 9),
              logs: 'done',
            ),
          ],
        ),
        logger: buildTestLogger(logOutput),
      );

      final events = await service.execute([
        '-i',
        'input.mp4',
        'output.mp4',
      ]).toList();

      expect(events, hasLength(3));
      expect(events[0].status, TaskStatus.running);
      expect(events[0].progress, 0);
      expect(events[1].status, TaskStatus.running);
      expect(events[1].progress, closeTo(0.35, 0.001));
      expect(events[2].status, TaskStatus.succeeded);
      expect(events[2].progress, 1);
      expect(events[2].message, 'done');
      expect(
        logOutput.lines.any((line) => line.contains('media.execute.start')),
        isTrue,
      );
      expect(
        logOutput.lines.any(
          (line) =>
              line.contains('media.execute.completed') &&
              line.contains('status=succeeded'),
        ),
        isTrue,
      );
    },
  );

  test('execute maps cancelled and failed completion codes', () async {
    final cancelled = MediaService(
      backend: FakeFFmpegKitBackend(
        executionEvents: const [
          MediaExecutionEvent.completed(returnCode: 255, logs: 'cancelled'),
        ],
      ),
    );
    final failed = MediaService(
      backend: FakeFFmpegKitBackend(
        executionEvents: const [
          MediaExecutionEvent.completed(
            returnCode: 1,
            logs: 'ffmpeg failed',
            failStackTrace: 'stack',
          ),
        ],
      ),
    );

    final cancelledEvents = await cancelled.execute([
      '-i',
      'input.mp4',
      'output.mp4',
    ]).toList();
    final failedEvents = await failed.execute([
      '-i',
      'input.mp4',
      'output.mp4',
    ]).toList();

    expect(cancelledEvents.last.status, TaskStatus.cancelled);
    expect(cancelledEvents.last.message, 'cancelled');
    expect(failedEvents.last.status, TaskStatus.failed);
    expect(failedEvents.last.message, 'ffmpeg failed\nstack');
  });
}

class FakeFFmpegKitBackend extends FFmpegKitBackend {
  FakeFFmpegKitBackend({
    this.probeSnapshot = const MediaProbeSnapshot(),
    this.executionEvents = const [],
  });

  final MediaProbeSnapshot probeSnapshot;
  final List<MediaExecutionEvent> executionEvents;

  @override
  Future<MediaProbeSnapshot> probe(String path) async {
    return probeSnapshot;
  }

  @override
  Stream<MediaExecutionEvent> execute(List<String> command) async* {
    for (final event in executionEvents) {
      yield event;
    }
  }
}
