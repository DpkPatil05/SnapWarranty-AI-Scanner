abstract class IReviewService {
  /// Requests an in-app review if available.
  Future<void> requestReview();

  /// Opens the store listing for the app.
  Future<void> openStoreListing();

  /// Increments an internal counter and triggers a review prompt if criteria are met.
  Future<void> checkAndRequestReview();
}
