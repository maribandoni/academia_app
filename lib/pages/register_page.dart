import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_repository.dart';
import '../models/usuario_model.dart';
import '../theme/app_colors.dart';
import '../utils/feedback.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/purple_button.dart';
import '../widgets/password_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register() {
    if (!_formKey.currentState!.validate()) {
      showFeedback(context, 'Preencha os campos obrigatórios corretamente.',
          error: true);
      return;
    }

    final user = UserModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
    if (!UserRepository.instance.register(user)) {
      showFeedback(
        context,
        'Este e-mail ou nome de usuário já está cadastrado.',
        error: true,
      );
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Voltar',
          icon: const Icon(Icons.arrow_back, color: AppColors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CRIAR CONTA',
          style: GoogleFonts.montserrat(
            color: AppColors.purple,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Nome Completo',
                  icon: Icons.person,
                  validator: (value) =>
                      Validators.required(value, 'Informe seu nome'),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _usernameController,
                  label: 'Nome de Usuário (@user)',
                  icon: Icons.alternate_email,
                  validator: (value) =>
                      Validators.required(value, 'Informe um nome de usuário'),
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _passwordController,
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Senha',
                  icon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme sua senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                GoldButton(label: 'CADASTRAR', onPressed: _register),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Já tenho conta? Voltar ao login',
                    style: TextStyle(
                      color: AppColors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}