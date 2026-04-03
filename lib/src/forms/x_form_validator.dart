/// Form validation utilities for common patterns.
///
/// Provides validators for email, phone, OTP, password, and more.
///
/// Example:
/// ```dart
/// TextFormField(
///   validator: XFormValidator.email(),
/// )
///
/// TextFormField(
///   validator: XFormValidator.password(),
/// )
/// ```
class XFormValidator {
  /// Validates email format
  /// 
  /// Returns error message if invalid, null if valid
  static String? Function(String?) email({bool allowEmpty = false}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return allowEmpty ? null : 'Email is required';
      }
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'Invalid email format';
      }
      return null;
    };
  }

  /// Validates phone number format
  /// 
  /// Accepts digits, spaces, hyphens, and plus sign
  static String? Function(String?) phone({
    bool allowEmpty = false,
    int minLength = 10,
    int maxLength = 15,
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return allowEmpty ? null : 'Phone number is required';
      }
      final cleanedPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
      if (cleanedPhone.length < minLength ||
          cleanedPhone.length > maxLength) {
        return 'Phone number must be between $minLength and $maxLength digits';
      }
      return null;
    };
  }

  /// Validates password strength
  /// 
  /// Requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one digit
  /// - At least one special character
  static String? Function(String?) password({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireDigit = true,
    bool requireSpecialChar = true,
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Password is required';
      }
      if (value.length < minLength) {
        return 'Password must be at least $minLength characters';
      }
      if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
        return 'Password must contain at least one uppercase letter';
      }
      if (requireDigit && !value.contains(RegExp(r'[0-9]'))) {
        return 'Password must contain at least one digit';
      }
      if (requireSpecialChar &&
          !value.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]'))) {
        return 'Password must contain at least one special character';
      }
      return null;
    };
  }

  /// Validates OTP (One-Time Password)
  /// 
  /// Typically 4-6 digits
  static String? Function(String?) otp({
    int length = 6,
    bool allowEmpty = false,
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return allowEmpty ? null : 'OTP is required';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'OTP must contain only digits';
      }
      if (value.length != length) {
        return 'OTP must be exactly $length digits';
      }
      return null;
    };
  }

  /// Validates URL format
  static String? Function(String?) url({bool allowEmpty = false}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return allowEmpty ? null : 'URL is required';
      }
      try {
        Uri.parse(value);
        if (!value.startsWith('http://') && !value.startsWith('https://')) {
          return 'URL must start with http:// or https://';
        }
        return null;
      } catch (e) {
        return 'Invalid URL format';
      }
    };
  }

  /// Validates username format
  /// 
  /// Allows alphanumeric characters, underscores, and hyphens
  static String? Function(String?) username({
    int minLength = 3,
    int maxLength = 20,
    bool allowEmpty = false,
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return allowEmpty ? null : 'Username is required';
      }
      if (value.length < minLength || value.length > maxLength) {
        return 'Username must be between $minLength and $maxLength characters';
      }
      if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(value)) {
        return 'Username can only contain letters, numbers, underscores, and hyphens';
      }
      return null;
    };
  }

  /// Validates that field is not empty
  static String? Function(String?) required({
    String message = 'This field is required',
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }

  /// Validates minimum length
  static String? Function(String?) minLength(
    int length, {
    String? message,
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Validates maximum length
  static String? Function(String?) maxLength(
    int length, {
    String? message,
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (value.length > length) {
        return message ?? 'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Validates that two fields match
  static String? Function(String?) match(
    String compareValue, {
    String fieldName = 'field',
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (value != compareValue) {
        return '$fieldName must match';
      }
      return null;
    };
  }

  /// Validates that value matches a regex pattern
  static String? Function(String?) pattern(
    String pattern, {
    String message = 'Invalid format',
    bool allowEmpty = false,
  }) {
    return (value) {
      if (value == null || value.isEmpty) {
        return allowEmpty ? null : message;
      }
      if (!RegExp(pattern).hasMatch(value)) {
        return message;
      }
      return null;
    };
  }

  /// Combines multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
