import 'package:lifetimer/data/models/user_model.dart';
import 'package:lifetimer/data/models/goal_model.dart';
import 'package:lifetimer/data/models/goal_step_model.dart';
import 'package:lifetimer/data/models/activity_model.dart';

/// Helper class to create test data
class TestData {
  /// Create a test user
  static User createTestUser({
    String id = 'test-user-id',
    String username = 'testuser',
    String email = 'test@example.com',
    String? avatarUrl,
    String? bio,
    bool isPublicProfile = false,
    DateTime? countdownStartDate,
    DateTime? countdownEndDate,
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      avatarUrl: avatarUrl,
      bio: bio,
      isPublicProfile: isPublicProfile,
      countdownStartDate: countdownStartDate,
      countdownEndDate: countdownEndDate,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  /// Create a test goal
  static Goal createTestGoal({
    String id = 'test-goal-id',
    String ownerId = 'test-user-id',
    String title = 'Test Goal',
    String? description,
    int progress = 0,
    double? locationLat,
    double? locationLng,
    String? locationName,
    String? imageUrl,
    bool completed = false,
  }) {
    return Goal(
      id: id,
      ownerId: ownerId,
      title: title,
      description: description,
      progress: progress,
      locationLat: locationLat,
      locationLng: locationLng,
      locationName: locationName,
      imageUrl: imageUrl,
      completed: completed,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    );
  }

  /// Create a test goal step
  static GoalStep createTestGoalStep({
    String id = 'test-step-id',
    String goalId = 'test-goal-id',
    String title = 'Test Step',
    bool isDone = false,
    int orderIndex = 0,
  }) {
    return GoalStep(
      id: id,
      goalId: goalId,
      title: title,
      isDone: isDone,
      orderIndex: orderIndex,
      createdAt: DateTime.now(),
    );
  }

  /// Create a test activity
  static Activity createTestActivity({
    String id = 'test-activity-id',
    String userId = 'test-user-id',
    String type = 'goal_created',
    Map<String, dynamic>? payload,
  }) {
    return Activity(
      id: id,
      userId: userId,
      type: type,
      payload: payload,
      createdAt: DateTime.now(),
    );
  }

  /// Create a list of test goals
  static List<Goal> createTestGoalsList({int count = 5}) {
    return List.generate(
      count,
      (index) => createTestGoal(
        id: 'goal-$index',
        title: 'Test Goal $index',
        progress: index * 20,
        completed: index == count - 1,
      ),
    );
  }

  /// Create a list of test goal steps
  static List<GoalStep> createTestStepsList({
    required String goalId,
    int count = 3,
  }) {
    return List.generate(
      count,
      (index) => createTestGoalStep(
        id: 'step-$index',
        goalId: goalId,
        title: 'Step $index',
        isDone: index < count ~/ 2,
        orderIndex: index,
      ),
    );
  }

  /// Create a list of test activities
  static List<Activity> createTestActivitiesList({int count = 5}) {
    final types = ['goal_created', 'goal_completed', 'countdown_started'];
    return List.generate(
      count,
      (index) => createTestActivity(
        id: 'activity-$index',
        type: types[index % types.length],
        payload: {'goal_id': 'goal-$index'},
      ),
    );
  }
}
