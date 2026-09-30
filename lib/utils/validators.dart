class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe seu e-mail';
    if (!_emailRegex.hasMatch(value.trim())) return 'Informe um e-mail válido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Informe a sua senha';
    if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }
}