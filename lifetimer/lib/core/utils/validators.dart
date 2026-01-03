class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (value.length > 20) {
      return 'Username must not exceed 20 characters';
    }
    
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null;
  }

  static String? validateGoalTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Goal title is required';
    }
    
    if (value.length > 100) {
      return 'Goal title must not exceed 100 characters';
    }
    
    return null;
  }

  static String? validateGoalDescription(String? value) {
    if (value != null && value.length > 500) {
      return 'Description must not exceed 500 characters';
    }
    
    return null;
  }

  static String? validateGoalProgress(int? value) {
    if (value == null) {
      return 'Progress is required';
    }
    
    if (value < 0 || value > 100) {
      return 'Progress must be between 0 and 100';
    }
    
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }
}
