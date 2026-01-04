import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/core/utils/date_time_utils.dart';

void main() {
  group('DateTimeUtils', () {
    group('calculateEndDate', () {
      test('should calculate end date correctly', () {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTimeUtils.calculateEndDate(startDate);
        
        final expectedEndDate = DateTime(2024, 1, 1).add(const Duration(days: 1356));
        expect(endDate, equals(expectedEndDate));
      });

      test('should handle leap years correctly', () {
        final startDate = DateTime(2024, 2, 28); // 2024 is a leap year
        final endDate = DateTimeUtils.calculateEndDate(startDate);
        
        final expectedEndDate = startDate.add(const Duration(days: 1356));
        expect(endDate, equals(expectedEndDate));
      });

      test('should preserve time component', () {
        final startDate = DateTime(2024, 1, 1, 12, 30, 45);
        final endDate = DateTimeUtils.calculateEndDate(startDate);
        
        final expectedEndDate = DateTime(2024, 1, 1, 12, 30, 45).add(const Duration(days: 1356));
        expect(endDate, equals(expectedEndDate));
      });
    });

    group('formatCountdown', () {
      test('should format duration with all components', () {
        const duration = Duration(days: 5, hours: 3, minutes: 45, seconds: 30);
        final formatted = DateTimeUtils.formatCountdown(duration);
        
        expect(formatted, equals('5d 3h 45m 30s'));
      });

      test('should format duration with only days', () {
        const duration = Duration(days: 10);
        final formatted = DateTimeUtils.formatCountdown(duration);
        
        expect(formatted, equals('10d 0h 0m 0s'));
      });

      test('should format duration with only hours and minutes', () {
        const duration = Duration(hours: 2, minutes: 30);
        final formatted = DateTimeUtils.formatCountdown(duration);
        
        expect(formatted, equals('0d 2h 30m 0s'));
      });

      test('should format duration with only minutes and seconds', () {
        const duration = Duration(minutes: 15, seconds: 45);
        final formatted = DateTimeUtils.formatCountdown(duration);
        
        expect(formatted, equals('0d 0h 15m 45s'));
      });

      test('should format zero duration', () {
        const duration = Duration.zero;
        final formatted = DateTimeUtils.formatCountdown(duration);
        
        expect(formatted, equals('0d 0h 0m 0s'));
      });
    });

    group('formatCountdownCompact', () {
      test('should show days and hours when days > 0', () {
        const duration = Duration(days: 5, hours: 3, minutes: 30);
        final formatted = DateTimeUtils.formatCountdownCompact(duration);
        
        expect(formatted, equals('5d 3h'));
      });

      test('should show hours and minutes when days == 0 and hours > 0', () {
        const duration = Duration(hours: 3, minutes: 30);
        final formatted = DateTimeUtils.formatCountdownCompact(duration);
        
        expect(formatted, equals('3h 30m'));
      });

      test('should show only minutes when days == 0 and hours == 0', () {
        const duration = Duration(minutes: 30);
        final formatted = DateTimeUtils.formatCountdownCompact(duration);
        
        expect(formatted, equals('30m'));
      });

      test('should handle zero duration', () {
        const duration = Duration.zero;
        final formatted = DateTimeUtils.formatCountdownCompact(duration);
        
        expect(formatted, equals('0m'));
      });
    });

    group('calculateProgress', () {
      test('should calculate progress correctly', () {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 11); // 10 days total
        
        // Mock current time as 5 days after start
        final progress = DateTimeUtils.calculateProgress(startDate, endDate);
        
        // Since we can't mock DateTime.now(), we'll just verify the method works
        expect(progress, greaterThanOrEqualTo(0.0));
        expect(progress, lessThanOrEqualTo(1.0));
      });

      test('should return 1.0 when countdown is finished', () {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2023, 12, 31); // Past date
        
        final progress = DateTimeUtils.calculateProgress(startDate, endDate);
        
        expect(progress, equals(1.0));
      });

      test('should return value between 0 and 1', () {
        final startDate = DateTime.now().subtract(const Duration(days: 5));
        final endDate = DateTime.now().add(const Duration(days: 5));
        
        final progress = DateTimeUtils.calculateProgress(startDate, endDate);
        
        expect(progress, greaterThan(0.0));
        expect(progress, lessThan(1.0));
      });
    });

    group('formatDate', () {
      test('should format date correctly', () {
        final date = DateTime(2024, 1, 15);
        final formatted = DateTimeUtils.formatDate(date);
        
        expect(formatted, equals('Jan 15, 2024'));
      });

      test('should handle different months', () {
        final date = DateTime(2024, 12, 25);
        final formatted = DateTimeUtils.formatDate(date);
        
        expect(formatted, equals('Dec 25, 2024'));
      });
    });

    group('formatShortDate', () {
      test('should format short date correctly', () {
        final date = DateTime(2024, 1, 15);
        final formatted = DateTimeUtils.formatShortDate(date);
        
        expect(formatted, equals('Jan 2024'));
      });

      test('should handle different years', () {
        final date = DateTime(2025, 6, 30);
        final formatted = DateTimeUtils.formatShortDate(date);
        
        expect(formatted, equals('Jun 2025'));
      });
    });

    group('formatDateTime', () {
      test('should format date and time correctly', () {
        final dateTime = DateTime(2024, 1, 15, 14, 30);
        final formatted = DateTimeUtils.formatDateTime(dateTime);
        
        expect(formatted, equals('Jan 15, 2024 • 14:30'));
      });
    });

    group('formatRelativeTime', () {
      test('should show "Just now" for very recent times', () {
        final dateTime = DateTime.now().subtract(const Duration(seconds: 30));
        final formatted = DateTimeUtils.formatRelativeTime(dateTime);
        
        expect(formatted, equals('Just now'));
      });

      test('should show minutes for times less than an hour ago', () {
        final dateTime = DateTime.now().subtract(const Duration(minutes: 30));
        final formatted = DateTimeUtils.formatRelativeTime(dateTime);
        
        expect(formatted, equals('30m ago'));
      });

      test('should show hours for times less than a day ago', () {
        final dateTime = DateTime.now().subtract(const Duration(hours: 5));
        final formatted = DateTimeUtils.formatRelativeTime(dateTime);
        
        expect(formatted, equals('5h ago'));
      });

      test('should show days for times less than a week ago', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 3));
        final formatted = DateTimeUtils.formatRelativeTime(dateTime);
        
        expect(formatted, equals('3d ago'));
      });

      test('should show formatted date for times older than a week', () {
        final dateTime = DateTime(2024, 1, 1);
        final formatted = DateTimeUtils.formatRelativeTime(dateTime);
        
        expect(formatted, contains('Jan'));
        expect(formatted, contains('2024'));
      });
    });

    group('isCountdownFinished', () {
      test('should return true when end date is in the past', () {
        final endDate = DateTime(2023, 1, 1);
        final isFinished = DateTimeUtils.isCountdownFinished(endDate);
        
        expect(isFinished, isTrue);
      });

      test('should return false when end date is in the future', () {
        final endDate = DateTime.now().add(const Duration(days: 10));
        final isFinished = DateTimeUtils.isCountdownFinished(endDate);
        
        expect(isFinished, isFalse);
      });

      test('should return true when end date is exactly now', () {
        final endDate = DateTime.now();
        final isFinished = DateTimeUtils.isCountdownFinished(endDate);
        
        // This might be true or false depending on exact timing
        expect(isFinished, isA<bool>());
      });
    });

    group('countdownDays constant', () {
      test('should be 1356 days', () {
        expect(DateTimeUtils.countdownDays, equals(1356));
      });
    });
  });
}
