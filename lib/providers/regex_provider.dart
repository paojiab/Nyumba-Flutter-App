extension extString on String {
  // example1@example1.example
  bool get isValidEmail {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(this);
  }

  // consists of alphabetical characters
  bool get isValidName {
    final nameRegExp = RegExp(r'^[a-zA-Z]+$');
    return nameRegExp.hasMatch(this);
  }

  // Password must contain an uppercase, lowercase, numeric digit and special character
  bool get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()]).{8,}$');
    return passwordRegExp.hasMatch(this);
  }

// Only enter last 8 digits of Ugandan Phone Number
  bool get isValidPhone {
    final phoneRegExp = RegExp(r'^\d{8}$');
    return phoneRegExp.hasMatch(this);
  }
}
