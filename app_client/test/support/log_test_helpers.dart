import 'package:logger/logger.dart';

class RecordingLogOutput extends LogOutput {
  final List<String> lines = <String>[];

  @override
  void output(OutputEvent event) {
    lines.addAll(event.lines);
  }
}

Logger buildTestLogger(RecordingLogOutput output) {
  return Logger(
    level: Level.trace,
    printer: SimplePrinter(colors: false, printTime: false),
    output: output,
  );
}
