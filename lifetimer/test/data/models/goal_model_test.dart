import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/data/models/goal_model.dart';

void main() {
  group('Goal Model', () {
    group('Constructor and Properties', () {
      test('should create Goal with required fields', () {
        final now = DateTime.now();
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: now,
          updatedAt: now,
        );

        expect(goal.id, equals('goal-1'));
        expect(goal.ownerId, equals('user-1'));
        expect(goal.title, equals('Test Goal'));
        expect(goal.description, isNull);
        expect(goal.progress, equals(0));
        expect(goal.locationLat, isNull);
        expect(goal.locationLng, isNull);
        expect(goal.locationName, isNull);
        expect(goal.imageUrl, isNull);
        expect(goal.completed, isFalse);
      });

      test('should create Goal with all fields', () {
        final now = DateTime.now();
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          description: 'Test description',
          progress: 50,
          locationLat: 40.7128,
          locationLng: -74.0060,
          locationName: 'New York',
          imageUrl: 'https://example.com/image.jpg',
          completed: false,
          createdAt: now,
          updatedAt: now,
        );

        expect(goal.id, equals('goal-1'));
        expect(goal.ownerId, equals('user-1'));
        expect(goal.title, equals('Test Goal'));
        expect(goal.description, equals('Test description'));
        expect(goal.progress, equals(50));
        expect(goal.locationLat, equals(40.7128));
        expect(goal.locationLng, equals(-74.0060));
        expect(goal.locationName, equals('New York'));
        expect(goal.imageUrl, equals('https://example.com/image.jpg'));
        expect(goal.completed, isFalse);
      });
    });

    group('Computed Properties', () {
      test('hasLocation should return false when location is null', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(goal.hasLocation, isFalse);
      });

      test('hasLocation should return false when only lat is set', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          locationLat: 40.7128,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(goal.hasLocation, isFalse);
      });

      test('hasLocation should return false when only lng is set', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          locationLng: -74.0060,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(goal.hasLocation, isFalse);
      });

      test('hasLocation should return true when both lat and lng are set', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          locationLat: 40.7128,
          locationLng: -74.0060,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(goal.hasLocation, isTrue);
      });

      test('hasImage should return false when imageUrl is null', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(goal.hasImage, isFalse);
      });

      test('hasImage should return false when imageUrl is empty', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          imageUrl: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(goal.hasImage, isFalse);
      });

      test('hasImage should return true when imageUrl is set', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          imageUrl: 'https://example.com/image.jpg',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(goal.hasImage, isTrue);
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        final now = DateTime.now();
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: now,
          updatedAt: now,
        );

        final updatedGoal = goal.copyWith(
          title: 'Updated Goal',
          progress: 75,
          completed: true,
        );

        expect(updatedGoal.id, equals(goal.id));
        expect(updatedGoal.ownerId, equals(goal.ownerId));
        expect(updatedGoal.title, equals('Updated Goal'));
        expect(updatedGoal.progress, equals(75));
        expect(updatedGoal.completed, isTrue);
      });

      test('should preserve original when no fields provided', () {
        final now = DateTime.now();
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: now,
          updatedAt: now,
        );

        final copiedGoal = goal.copyWith();

        expect(copiedGoal.id, equals(goal.id));
        expect(copiedGoal.title, equals(goal.title));
        expect(copiedGoal.progress, equals(goal.progress));
      });
    });

    group('toJson and fromJson', () {
      test('should serialize to JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          description: 'Test description',
          progress: 50,
          locationLat: 40.7128,
          locationLng: -74.0060,
          locationName: 'New York',
          imageUrl: 'https://example.com/image.jpg',
          completed: false,
          createdAt: now,
          updatedAt: now,
        );

        final json = goal.toJson();

        expect(json['id'], equals('goal-1'));
        expect(json['owner_id'], equals('user-1'));
        expect(json['title'], equals('Test Goal'));
        expect(json['description'], equals('Test description'));
        expect(json['progress'], equals(50));
        expect(json['location_lat'], equals(40.7128));
        expect(json['location_lng'], equals(-74.0060));
        expect(json['location_name'], equals('New York'));
        expect(json['image_url'], equals('https://example.com/image.jpg'));
        expect(json['completed'], isFalse);
        expect(json['created_at'], equals(now.toIso8601String()));
        expect(json['updated_at'], equals(now.toIso8601String()));
      });

      test('should deserialize from JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final json = {
          'id': 'goal-1',
          'owner_id': 'user-1',
          'title': 'Test Goal',
          'description': 'Test description',
          'progress': 50,
          'location_lat': 40.7128,
          'location_lng': -74.0060,
          'location_name': 'New York',
          'image_url': 'https://example.com/image.jpg',
          'completed': false,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        final goal = Goal.fromJson(json);

        expect(goal.id, equals('goal-1'));
        expect(goal.ownerId, equals('user-1'));
        expect(goal.title, equals('Test Goal'));
        expect(goal.description, equals('Test description'));
        expect(goal.progress, equals(50));
        expect(goal.locationLat, equals(40.7128));
        expect(goal.locationLng, equals(-74.0060));
        expect(goal.locationName, equals('New York'));
        expect(goal.imageUrl, equals('https://example.com/image.jpg'));
        expect(goal.completed, isFalse);
      });

      test('should handle null optional fields in JSON', () {
        final now = DateTime(2024, 1, 1);
        final json = {
          'id': 'goal-1',
          'owner_id': 'user-1',
          'title': 'Test Goal',
          'description': null,
          'progress': null,
          'location_lat': null,
          'location_lng': null,
          'location_name': null,
          'image_url': null,
          'completed': null,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        final goal = Goal.fromJson(json);

        expect(goal.description, isNull);
        expect(goal.progress, equals(0));
        expect(goal.locationLat, isNull);
        expect(goal.locationLng, isNull);
        expect(goal.locationName, isNull);
        expect(goal.imageUrl, isNull);
        expect(goal.completed, isFalse);
      });

      test('should roundtrip through JSON', () {
        final goal = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          description: 'Test description',
          progress: 50,
          locationLat: 40.7128,
          locationLng: -74.0060,
          locationName: 'New York',
          imageUrl: 'https://example.com/image.jpg',
          completed: false,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        final json = goal.toJson();
        final deserializedGoal = Goal.fromJson(json);

        expect(deserializedGoal.id, equals(goal.id));
        expect(deserializedGoal.ownerId, equals(goal.ownerId));
        expect(deserializedGoal.title, equals(goal.title));
        expect(deserializedGoal.description, equals(goal.description));
        expect(deserializedGoal.progress, equals(goal.progress));
        expect(deserializedGoal.locationLat, equals(goal.locationLat));
        expect(deserializedGoal.locationLng, equals(goal.locationLng));
        expect(deserializedGoal.locationName, equals(goal.locationName));
        expect(deserializedGoal.imageUrl, equals(goal.imageUrl));
        expect(deserializedGoal.completed, equals(goal.completed));
      });
    });

    group('Equatable', () {
      test('should be equal when all properties match', () {
        final now = DateTime.now();
        final goal1 = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: now,
          updatedAt: now,
        );

        final goal2 = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: now,
          updatedAt: now,
        );

        expect(goal1, equals(goal2));
        expect(goal1.hashCode, equals(goal2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final now = DateTime.now();
        final goal1 = Goal(
          id: 'goal-1',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: now,
          updatedAt: now,
        );

        final goal2 = Goal(
          id: 'goal-2',
          ownerId: 'user-1',
          title: 'Test Goal',
          createdAt: now,
          updatedAt: now,
        );

        expect(goal1, isNot(equals(goal2)));
      });
    });
  });
}
