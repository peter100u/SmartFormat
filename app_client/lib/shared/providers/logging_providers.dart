import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../core/logging/app_logger.dart';

final loggerProvider = Provider<Logger>((ref) {
  return appLogger;
});
