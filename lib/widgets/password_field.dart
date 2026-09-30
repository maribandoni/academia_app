import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_text_field.dart';

/// Campo de senha com ícone de olho para mostrar/ocultar o texto.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Senha',
    this.icon = Icons.lock,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      icon: widget.icon,
      obscureText: _obscure,
      validator: widget.validator,
      suffixIcon: IconButton(
        tooltip: _obscure ? 'Mostrar senha' : 'Ocultar senha',
        icon: Icon(
          _obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.purple,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}