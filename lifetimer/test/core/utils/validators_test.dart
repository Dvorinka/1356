import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('should return error for empty email', () {
        expect(Validators.validateEmail(''), equals('Email is required'));
        expect(Validators.validateEmail(null), equals('Email is required'));
      });

      test('should return error for invalid email format', () {
        expect(Validators.validateEmail('invalid'), equals('Please enter a valid email address'));
        expect(Validators.validateEmail('invalid@'), equals('Please enter a valid email address'));
        expect(Validators.validateEmail('@example.com'), equals('Please enter a valid email address'));
        expect(Validators.validateEmail('test@'), equals('Please enter a valid email address'));
      });

      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(Validators.validateEmail('test_user+tag@example.com'), isNull);
      });

      test('should handle edge cases', () {
        expect(Validators.validateEmail('a@b.c'), isNull);
        expect(Validators.validateEmail('test@test.test'), isNull);
      });
    });

    group('validatePassword', () {
      test('should return error for empty password', () {
        expect(Validators.validatePassword(''), equals('Password must be at least 6 characters'));
        expect(Validators.validatePassword(null), equals('Password is required'));
      });

      test('should return error for password less than 6 characters', () {
        expect(Validators.validatePassword('12345'), equals('Password must be at least 6 characters'));
        expect(Validators.validatePassword('abc'), equals('Password must be at least 6 characters'));
      });

      test('should return null for valid password', () {
        expect(Validators.validatePassword('123456'), isNull);
        expect(Validators.validatePassword('password'), isNull);
        expect(Validators.validatePassword('P@ssw0rd!'), isNull);
      });
    });

    group('validateUsername', () {
      test('should return error for empty username', () {
        expect(Validators.validateUsername(''), equals('Username is required'));
        expect(Validators.validateUsername(null), equals('Username is required'));
      });

      test('should return error for username less than 3 characters', () {
        expect(Validators.validateUsername('ab'), equals('Username must be at least 3 characters'));
        expect(Validators.validateUsername('a'), equals('Username must be at least 3 characters'));
      });

      test('should return error for username more than 20 characters', () {
        expect(Validators.validateUsername('a' * 21), equals('Username must not exceed 20 characters'));
      });

      test('should return error for username with invalid characters', () {
        expect(Validators.validateUsername('user name'), equals('Username can only contain letters, numbers, and underscores'));
        expect(Validators.validateUsername('user-name'), equals('Username can only contain letters, numbers, and underscores'));
        expect(Validators.validateUsername('user.name'), equals('Username can only contain letters, numbers, and underscores'));
        expect(Validators.validateUsername('user@name'), equals('Username can only contain letters, numbers, and underscores'));
      });

      test('should return null for valid username', () {
        expect(Validators.validateUsername('user'), isNull);
        expect(Validators.validateUsername('user123'), isNull);
        expect(Validators.validateUsername('user_name'), isNull);
        expect(Validators.validateUsername('User_Name_123'), isNull);
        expect(Validators.validateUsername('a' * 20), isNull);
      });
    });

    group('validateGoalTitle', () {
      test('should return error for empty title', () {
        expect(Validators.validateGoalTitle(''), equals('Goal title is required'));
        expect(Validators.validateGoalTitle(null), equals('Goal title is required'));
      });

      test('should return error for title more than 100 characters', () {
        expect(Validators.validateGoalTitle('a' * 101), equals('Goal title must not exceed 100 characters'));
      });

      test('should return null for valid title', () {
        expect(Validators.validateGoalTitle('Learn to play guitar'), isNull);
        expect(Validators.validateGoalTitle('a' * 100), isNull);
        expect(Validators.validateGoalTitle('Run a marathon'), isNull);
      });
    });

    group('validateGoalDescription', () {
      test('should return null for empty description', () {
        expect(Validators.validateGoalDescription(''), isNull);
        expect(Validators.validateGoalDescription(null), isNull);
      });

      test('should return error for description more than 500 characters', () {
        expect(Validators.validateGoalDescription('a' * 501), equals('Description must not exceed 500 characters'));
      });

      test('should return null for valid description', () {
        expect(Validators.validateGoalDescription('A short description'), isNull);
        expect(Validators.validateGoalDescription('a' * 500), isNull);
      });
    });

    group('validateGoalProgress', () {
      test('should return error for null progress', () {
        expect(Validators.validateGoalProgress(null), equals('Progress is required'));
      });

      test('should return error for negative progress', () {
        expect(Validators.validateGoalProgress(-1), equals('Progress must be between 0 and 100'));
        expect(Validators.validateGoalProgress(-100), equals('Progress must be between 0 and 100'));
      });

      test('should return error for progress greater than 100', () {
        expect(Validators.validateGoalProgress(101), equals('Progress must be between 0 and 100'));
        expect(Validators.validateGoalProgress(150), equals('Progress must be between 0 and 100'));
      });

      test('should return null for valid progress', () {
        expect(Validators.validateGoalProgress(0), isNull);
        expect(Validators.validateGoalProgress(50), isNull);
        expect(Validators.validateGoalProgress(100), isNull);
      });
    });

    group('validateRequired', () {
      test('should return error for empty value', () {
        expect(Validators.validateRequired('', 'Name'), equals('Name is required'));
        expect(Validators.validateRequired(null, 'Name'), equals('Name is required'));
      });

      test('should return null for valid value', () {
        expect(Validators.validateRequired('John', 'Name'), isNull);
        expect(Validators.validateRequired('123', 'Code'), isNull);
      });

      test('should use provided field name in error message', () {
        expect(Validators.validateRequired('', 'Email'), equals('Email is required'));
        expect(Validators.validateRequired('', 'Password'), equals('Password is required'));
      });
    });
  });
}
