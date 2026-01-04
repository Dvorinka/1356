import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/data/models/user_model.dart';

void main() {
  group('User Model', () {
    group('Constructor and Properties', () {
      test('should create User with required fields', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        expect(user.id, equals('user-1'));
        expect(user.username, equals('testuser'));
        expect(user.email, equals('test@example.com'));
        expect(user.avatarUrl, isNull);
        expect(user.bio, isNull);
        expect(user.isPublicProfile, isFalse);
        expect(user.countdownStartDate, isNull);
        expect(user.countdownEndDate, isNull);
      });

      test('should create User with all fields', () {
        final now = DateTime.now();
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          avatarUrl: 'https://example.com/avatar.jpg',
          bio: 'Test bio',
          isPublicProfile: true,
          countdownStartDate: now,
          countdownEndDate: now.add(const Duration(days: 1356)),
          createdAt: now,
          updatedAt: now,
        );

        expect(user.id, equals('user-1'));
        expect(user.username, equals('testuser'));
        expect(user.email, equals('test@example.com'));
        expect(user.avatarUrl, equals('https://example.com/avatar.jpg'));
        expect(user.bio, equals('Test bio'));
        expect(user.isPublicProfile, isTrue);
        expect(user.countdownStartDate, equals(now));
        expect(user.countdownEndDate, equals(now.add(const Duration(days: 1356))));
      });
    });

    group('Computed Properties', () {
      test('hasCountdownStarted should return false when countdownStartDate is null', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.hasCountdownStarted, isFalse);
      });

      test('hasCountdownStarted should return true when countdownStartDate is set', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          countdownStartDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.hasCountdownStarted, isTrue);
      });

      test('isCountdownActive should return false when countdown not started', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.isCountdownActive, isFalse);
      });

      test('isCountdownActive should return true when countdown is active', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          countdownStartDate: DateTime.now().subtract(const Duration(days: 10)),
          countdownEndDate: DateTime.now().add(const Duration(days: 1346)),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.isCountdownActive, isTrue);
      });

      test('isCountdownActive should return false when countdown has ended', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          countdownStartDate: DateTime(2023, 1, 1),
          countdownEndDate: DateTime(2023, 12, 31),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 12, 31),
        );

        expect(user.isCountdownActive, isFalse);
      });

      test('daysRemaining should return null when countdown not active', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.daysRemaining, isNull);
      });

      test('daysRemaining should return correct days when countdown is active', () {
        final endDate = DateTime.now().add(const Duration(days: 100));
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          countdownStartDate: DateTime.now(),
          countdownEndDate: endDate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final daysRemaining = user.daysRemaining;
        expect(daysRemaining, isNotNull);
        expect(daysRemaining, greaterThan(0));
        expect(daysRemaining, lessThanOrEqualTo(100));
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final updatedUser = user.copyWith(
          username: 'newuser',
          bio: 'New bio',
        );

        expect(updatedUser.id, equals(user.id));
        expect(updatedUser.username, equals('newuser'));
        expect(updatedUser.email, equals(user.email));
        expect(updatedUser.bio, equals('New bio'));
      });

      test('should preserve original when no fields provided', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final copiedUser = user.copyWith();

        expect(copiedUser.id, equals(user.id));
        expect(copiedUser.username, equals(user.username));
        expect(copiedUser.email, equals(user.email));
      });
    });

    group('toJson and fromJson', () {
      test('should serialize to JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          avatarUrl: 'https://example.com/avatar.jpg',
          bio: 'Test bio',
          isPublicProfile: true,
          countdownStartDate: now,
          countdownEndDate: now.add(const Duration(days: 1356)),
          createdAt: now,
          updatedAt: now,
        );

        final json = user.toJson();

        expect(json['id'], equals('user-1'));
        expect(json['username'], equals('testuser'));
        expect(json['email'], equals('test@example.com'));
        expect(json['avatar_url'], equals('https://example.com/avatar.jpg'));
        expect(json['bio'], equals('Test bio'));
        expect(json['is_public_profile'], isTrue);
        expect(json['countdown_start_date'], equals(now.toIso8601String()));
        expect(json['countdown_end_date'], equals(now.add(const Duration(days: 1356)).toIso8601String()));
        expect(json['created_at'], equals(now.toIso8601String()));
        expect(json['updated_at'], equals(now.toIso8601String()));
      });

      test('should deserialize from JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final json = {
          'id': 'user-1',
          'username': 'testuser',
          'email': 'test@example.com',
          'avatar_url': 'https://example.com/avatar.jpg',
          'bio': 'Test bio',
          'is_public_profile': true,
          'countdown_start_date': now.toIso8601String(),
          'countdown_end_date': now.add(const Duration(days: 1356)).toIso8601String(),
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        final user = User.fromJson(json);

        expect(user.id, equals('user-1'));
        expect(user.username, equals('testuser'));
        expect(user.email, equals('test@example.com'));
        expect(user.avatarUrl, equals('https://example.com/avatar.jpg'));
        expect(user.bio, equals('Test bio'));
        expect(user.isPublicProfile, isTrue);
        expect(user.countdownStartDate, equals(now));
        expect(user.countdownEndDate, equals(now.add(const Duration(days: 1356))));
      });

      test('should handle null optional fields in JSON', () {
        final now = DateTime(2024, 1, 1);
        final json = {
          'id': 'user-1',
          'username': 'testuser',
          'email': 'test@example.com',
          'avatar_url': null,
          'bio': null,
          'is_public_profile': null,
          'countdown_start_date': null,
          'countdown_end_date': null,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        final user = User.fromJson(json);

        expect(user.avatarUrl, isNull);
        expect(user.bio, isNull);
        expect(user.isPublicProfile, isFalse);
        expect(user.countdownStartDate, isNull);
        expect(user.countdownEndDate, isNull);
      });

      test('should roundtrip through JSON', () {
        final user = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          avatarUrl: 'https://example.com/avatar.jpg',
          bio: 'Test bio',
          isPublicProfile: true,
          countdownStartDate: DateTime(2024, 1, 1),
          countdownEndDate: DateTime(2024, 1, 1).add(const Duration(days: 1356)),
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        final json = user.toJson();
        final deserializedUser = User.fromJson(json);

        expect(deserializedUser.id, equals(user.id));
        expect(deserializedUser.username, equals(user.username));
        expect(deserializedUser.email, equals(user.email));
        expect(deserializedUser.avatarUrl, equals(user.avatarUrl));
        expect(deserializedUser.bio, equals(user.bio));
        expect(deserializedUser.isPublicProfile, equals(user.isPublicProfile));
        expect(deserializedUser.countdownStartDate, equals(user.countdownStartDate));
        expect(deserializedUser.countdownEndDate, equals(user.countdownEndDate));
      });
    });

    group('Equatable', () {
      test('should be equal when all properties match', () {
        final now = DateTime.now();
        final user1 = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: now,
          updatedAt: now,
        );

        final user2 = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: now,
          updatedAt: now,
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final now = DateTime.now();
        final user1 = User(
          id: 'user-1',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: now,
          updatedAt: now,
        );

        final user2 = User(
          id: 'user-2',
          username: 'testuser',
          email: 'test@example.com',
          createdAt: now,
          updatedAt: now,
        );

        expect(user1, isNot(equals(user2)));
      });
    });
  });
}
