class Validators {
  static String? name(String? value) 
  {
    if (value == null || value.trim().isEmpty) return 'Enter the name';
    if (value.trim().length < 2) return 'Name is too short';
    return null;
  }

  static String? rollNo(String? value) 
  {
    if (value == null || value.trim().isEmpty) return 'Enter the roll number';
    return null;
  }

  static String? email(String? value) 
  {
    if (value == null || value.trim().isEmpty) return 'Enter an email address';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) 
  {
    if (value == null || value.isEmpty) return 'Enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) 
  {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? phone(String? value) 
  {
    if (value == null || value.isEmpty) return 'Enter a phone number';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? required(String? value, String field) 
  {
  if (value == null || value.trim().isEmpty) return 'Enter the $field';
  if (value.trim().length < 3) return 'The $field is too short';
  return null;
  }
}
