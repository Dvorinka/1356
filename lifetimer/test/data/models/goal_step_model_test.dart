import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/data/models/goal_step_model.dart';

void main() {
  group('GoalStep Model', () {
    group('Constructor and Properties', () {
      test('should create GoalStep with required fields', () {
        final now = DateTime.now();
        final step = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        expect(step.id, equals('step-1'));
        expect(step.goalId, equals('goal-1'));
        expect(step.title, equals('Test Step'));
        expect(step.isDone, isFalse);
        expect(step.orderIndex, equals(0));
      });

      test('should create GoalStep with isDone true', () {
        final now = DateTime.now();
        final step = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Completed Step',
          isDone: true,
          orderIndex: 1,
          createdAt: now,
        );

        expect(step.id, equals('step-1'));
        expect(step.goalId, equals('goal-1'));
        expect(step.title, equals('Completed Step'));
        expect(step.isDone, isTrue);
        expect(step.orderIndex, equals(1));
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        final now = DateTime.now();
        final step = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        final updatedStep = step.copyWith(
          title: 'Updated Step',
          isDone: true,
          orderIndex: 1,
        );

        expect(updatedStep.id, equals(step.id));
        expect(updatedStep.goalId, equals(step.goalId));
        expect(updatedStep.title, equals('Updated Step'));
        expect(updatedStep.isDone, isTrue);
        expect(updatedStep.orderIndex, equals(1));
      });

      test('should preserve original when no fields provided', () {
        final now = DateTime.now();
        final step = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        final copiedStep = step.copyWith();

        expect(copiedStep.id, equals(step.id));
        expect(copiedStep.title, equals(step.title));
        expect(copiedStep.isDone, equals(step.isDone));
        expect(copiedStep.orderIndex, equals(step.orderIndex));
      });
    });

    group('toJson and fromJson', () {
      test('should serialize to JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final step = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        final json = step.toJson();

        expect(json['id'], equals('step-1'));
        expect(json['goal_id'], equals('goal-1'));
        expect(json['title'], equals('Test Step'));
        expect(json['is_done'], isFalse);
        expect(json['order_index'], equals(0));
        expect(json['created_at'], equals(now.toIso8601String()));
      });

      test('should deserialize from JSON correctly', () {
        final now = DateTime(2024, 1, 1, 12, 0, 0);
        final json = {
          'id': 'step-1',
          'goal_id': 'goal-1',
          'title': 'Test Step',
          'is_done': false,
          'order_index': 0,
          'created_at': now.toIso8601String(),
        };

        final step = GoalStep.fromJson(json);

        expect(step.id, equals('step-1'));
        expect(step.goalId, equals('goal-1'));
        expect(step.title, equals('Test Step'));
        expect(step.isDone, isFalse);
        expect(step.orderIndex, equals(0));
      });

      test('should handle null optional fields in JSON', () {
        final now = DateTime(2024, 1, 1);
        final json = {
          'id': 'step-1',
          'goal_id': 'goal-1',
          'title': 'Test Step',
          'is_done': null,
          'order_index': null,
          'created_at': now.toIso8601String(),
        };

        final step = GoalStep.fromJson(json);

        expect(step.isDone, isFalse);
        expect(step.orderIndex, equals(0));
      });

      test('should roundtrip through JSON', () {
        final step = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: true,
          orderIndex: 2,
          createdAt: DateTime(2024, 1, 1),
        );

        final json = step.toJson();
        final deserializedStep = GoalStep.fromJson(json);

        expect(deserializedStep.id, equals(step.id));
        expect(deserializedStep.goalId, equals(step.goalId));
        expect(deserializedStep.title, equals(step.title));
        expect(deserializedStep.isDone, equals(step.isDone));
        expect(deserializedStep.orderIndex, equals(step.orderIndex));
      });
    });

    group('Equatable', () {
      test('should be equal when all properties match', () {
        final now = DateTime.now();
        final step1 = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        final step2 = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        expect(step1, equals(step2));
        expect(step1.hashCode, equals(step2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final now = DateTime.now();
        final step1 = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        final step2 = GoalStep(
          id: 'step-2',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        expect(step1, isNot(equals(step2)));
      });

      test('should not be equal when isDone differs', () {
        final now = DateTime.now();
        final step1 = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: false,
          orderIndex: 0,
          createdAt: now,
        );

        final step2 = GoalStep(
          id: 'step-1',
          goalId: 'goal-1',
          title: 'Test Step',
          isDone: true,
          orderIndex: 0,
          createdAt: now,
        );

        expect(step1, isNot(equals(step2)));
      });
    });
  });
}
