import 'package:logger/logger.dart';

Logger buildAppLogger({
  LogFilter? filter,
  LogPrinter? printer,
  LogOutput? output,
  Level level = Level.trace,
}) {
  return Logger(
    filter: filter,
    printer: printer ?? SimplePrinter(colors: false, printTime: true),
    output: output,
    level: level,
  );
}

final Logger appLogger = buildAppLogger();
