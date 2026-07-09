/// Sends user feedback and failed-task diagnostics through the chosen channel.
///
/// Boundary:
/// - Settings and failed-task flows call this service through a controller.
/// - Mail/app-launch/plugin side effects stay here.
/// - Attach only concise logs/error summaries, never raw user media.
abstract class FeedbackService {
  Future<void> sendFeedback({required String subject, required String body});
}

class PendingFeedbackService implements FeedbackService {
  const PendingFeedbackService();

  @override
  Future<void> sendFeedback({
    required String subject,
    required String body,
  }) async {
    // TODO(mvp): Open a mailto/support flow with app version and error context.
  }
}
