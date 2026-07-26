import 'dart:developer' as dev;

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/services/review_service_interface.dart';

class ReviewService implements IReviewService {
  ReviewService._internal();

  static final ReviewService instance = ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;
  static const String _reviewActionCountKey = 'review_action_count';
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.deepx.snap_warranty';

  @override
  Future<void> requestReview() async {
    try {
      if (await _inAppReview.isAvailable()) {
        dev.log('Requesting In-App Review...', name: 'ReviewService');
        await _inAppReview.requestReview();
      } else {
        dev.log(
          'In-App Review not available, opening store listing...',
          name: 'ReviewService',
        );
        await openStoreListing();
      }
    } catch (e) {
      dev.log('In-App Review failed: $e', name: 'ReviewService');
    }
  }

  @override
  Future<void> openStoreListing() async {
    try {
      dev.log(
        'Opening store listing via native intent...',
        name: 'ReviewService',
      );
      await _inAppReview.openStoreListing();
    } catch (e) {
      dev.log(
        'Native store listing failed, falling back to browser: $e',
        name: 'ReviewService',
      );
      await _launchFallbackUrl();
    }
  }

  Future<void> _launchFallbackUrl() async {
    try {
      final uri = Uri.parse(_playStoreUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      dev.log('Browser fallback failed: $e', name: 'ReviewService');
    }
  }

  @override
  Future<void> checkAndRequestReview() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_reviewActionCountKey) ?? 0;
    count++;
    await prefs.setInt(_reviewActionCountKey, count);

    dev.log('Review action count: $count', name: 'ReviewService');

    // Trigger on 3rd, 10th, and every 50th action
    if (count == 3 || count == 10 || (count > 0 && count % 50 == 0)) {
      await requestReview();
    }
  }
}
