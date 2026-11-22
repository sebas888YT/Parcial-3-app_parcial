String? requiredFieldValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Este campo es obligatorio.';
  }
  return null;
}

String? emailValidator(String? value) {
  final requiredError = requiredFieldValidator(value);
  if (requiredError != null) return requiredError;

  final email = value!.trim();
  final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailPattern.hasMatch(email)) {
    return 'Ingresa un correo electrónico válido.';
  }
  return null;
}

String? passwordValidator(String? value) {
  final requiredError = requiredFieldValidator(value);
  if (requiredError != null) return requiredError;
  if (value!.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres.';
  }
  return null;
}

String? confirmPasswordValidator(String? value, String password) {
  final requiredError = requiredFieldValidator(value);
  if (requiredError != null) return requiredError;
  if (value != password) return 'Las contraseñas no coinciden.';
  return null;
}
