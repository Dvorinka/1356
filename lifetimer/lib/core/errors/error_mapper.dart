import 'package:supabase_flutter/supabase_flutter.dart';
import 'failure.dart';

class ErrorMapper {
  static Failure mapError(dynamic error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return const AuthFailure('Invalid email or password');
        case 'Email not confirmed':
          return const AuthFailure('Please confirm your email address');
        case 'User already registered':
          return const AuthFailure('An account with this email already exists');
        case 'Password should be at least 6 characters':
          return const AuthFailure('Password must be at least 6 characters');
        default:
          return AuthFailure(error.message);
      }
    }

    if (error is PostgrestException) {
      switch (error.code) {
        case '23505':
          return const ValidationFailure('This record already exists');
        case '23503':
          return const ValidationFailure('Referenced record does not exist');
        case '42501':
          return const PermissionFailure('You do not have permission to perform this action');
        default:
          return ServerFailure(
            error.message,
            statusCode: int.tryParse(error.code ?? ''),
          );
      }
    }

    if (error is Exception) {
      return NetworkFailure(error.toString().replaceAll('Exception: ', ''));
    }

    return UnknownFailure(error.toString());
  }

  static String getUserMessage(Failure failure) {
    return failure.message;
  }
}
