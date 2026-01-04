import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/data/models/activity_model.dart';

void main() {
  group('Activity Model', () {
    group('Constructor and Properties', () {
      test('should create Activity with required fields', () {
        final now = DateTime.now();
        final activity = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        expect(activity.id, equals('activity-1'));
        expect(activity.userId, equals('user-1'));
        expect(activity.type, equals('goal_created'));
        expect(activity.payload, isNull);
      });

      test('should create Activity with payload', () {
        final now = DateTime.now();
        final payload = {'goal_id': 'goal-1', 'title': 'Test Goal'};
        final activity = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_completed',
          payload: payload,
          createdAt: now,
        );

        expect(activity.id, equals('activity-1'));
        expect(activity.userId, equals('user-1'));
        expect(activity.type, equals('goal_completed'));
        expect(activity.payload, equals(payload));
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        final now = DateTime.now();
        final activity = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        final updatedActivity = activity.copyWith(
          type: 'goal_completed',
          payload: const {'goal_id': 'goal-1'},
        );

        expect(updatedActivity.id, equals(activity.id));
        expect(updatedActivity.userId, equals(activity.userId));
        expect(updatedActivity.type, equals('goal_completed'));
        expect(updatedActivity.payload, equals({'goal_id': 'goal-1'}));
      });

      test('should preserve original when no fields provided', () {
        final now = DateTime.now();
        final activity = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        final copiedActivity = activity.copyWith();

        expect(copiedActivity.id, equals(activity.id));
        expect(copiedActivity.type, equals(activity.type));
        expect(copiedActivity.payload, equals(activity.payload));
      });
    });

    group('toJson and fromJson', () {
      test('should serialize to JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final payload = {'goal_id': 'goal-1', 'title': 'Test Goal'};
        final activity = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_completed',
          payload: payload,
          createdAt: now,
        );

        final json = activity.toJson();

        expect(json['id'], equals('activity-1'));
        expect(json['user_id'], equals('user-1'));
        expect(json['type'], equals('goal_completed'));
        expect(json['payload'], equals(payload));
        expect(json['created_at'], equals(now.toIso8601String()));
      });

      test('should deserialize from JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final payload = {'goal_id': 'goal-1', 'title': 'Test Goal'};
        final json = {
          'id': 'activity-1',
          'user_id': 'user-1',
          'type': 'goal_completed',
          'payload': payload,
          'created_at': now.toIso8601String(),
        };

        final activity = Activity.fromJson(json);

        expect(activity.id, equals('activity-1'));
        expect(activity.userId, equals('user-1'));
        expect(activity.type, equals('goal_completed'));
        expect(activity.payload, equals(payload));
      });

      test('should handle null payload in JSON', () {
        final now = DateTime(2024, 1, 1);
        final json = {
          'id': 'activity-1',
          'user_id': 'user-1',
          'type': 'countdown_started',
          'payload': null,
          'created_at': now.toIso8601String(),
        };

        final activity = Activity.fromJson(json);

        expect(activity.payload, isNull);
      });

      test('should roundtrip through JSON', () {
        final payload = {'goal_id': 'goal-1', 'progress': 100};
        final activity = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_completed',
          payload: payload,
          createdAt: DateTime(2024, 1, 1),
        );

        final json = activity.toJson();
        final deserializedActivity = Activity.fromJson(json);

        expect(deserializedActivity.id, equals(activity.id));
        expect(deserializedActivity.userId, equals(activity.userId));
        expect(deserializedActivity.type, equals(activity.type));
        expect(deserializedActivity.payload, equals(activity.payload));
      });
    });

    group('Equatable', () {
      test('should be equal when all properties match', () {
        final now = DateTime.now();
        final activity1 = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        final activity2 = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        expect(activity1, equals(activity2));
        expect(activity1.hashCode, equals(activity2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final now = DateTime.now();
        final activity1 = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        final activity2 = Activity(
          id: 'activity-2',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        expect(activity1, isNot(equals(activity2)));
      });

      test('should not be equal when type differs', () {
        final now = DateTime.now();
        final activity1 = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_created',
          createdAt: now,
        );

        final activity2 = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_completed',
          createdAt: now,
        );

        expect(activity1, isNot(equals(activity2)));
      });

      test('should not be equal when payload differs', () {
        final now = DateTime.now();
        final activity1 = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_completed',
          payload: const {'goal_id': 'goal-1'},
          createdAt: now,
        );

        final activity2 = Activity(
          id: 'activity-1',
          userId: 'user-1',
          type: 'goal_completed',
          payload: const {'goal_id': 'goal-2'},
          createdAt: now,
        );

        expect(activity1, isNot(equals(activity2)));
      });
    });

    group('Activity Types', () {
      test('should support various activity types', () {
        const types = [
          'goal_created',
          'goal_completed',
          'countdown_started',
          'countdown_finished',
          'milestone_reached',
          'profile_updated',
        ];

        for (final type in types) {
          final activity = Activity(
            id: 'activity-$type',
            userId: 'user-1',
            type: type,
            createdAt: DateTime.now(),
          );

          expect(activity.type, equals(type));
        }
      });
    });
  });
}
