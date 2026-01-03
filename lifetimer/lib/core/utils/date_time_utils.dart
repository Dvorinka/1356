import 'package:intl/intl.dart';

class DateTimeUtils {
  static const int countdownDays = 1356;

  static DateTime calculateEndDate(DateTime startDate) {
    return startDate.add(const Duration(days: countdownDays));
  }

  static Duration calculateRemainingTime(DateTime endDate) {
    return endDate.difference(DateTime.now());
  }

  static String formatCountdown(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  static String formatCountdownCompact(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  static double calculateProgress(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final totalDuration = endDate.difference(startDate).inSeconds;
    final elapsedDuration = now.difference(startDate).inSeconds;

    if (elapsedDuration >= totalDuration) {
      return 1.0;
    }

    return elapsedDuration / totalDuration;
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • HH:mm').format(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(dateTime);
    }
  }

  static bool isCountdownFinished(DateTime endDate) {
    return DateTime.now().isAfter(endDate);
  }
}
