import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_repository.dart';
import '../theme/app_colors.dart';
import '../utils/feedback.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/purple_button.dart';
import '../widgets/password_field.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (!_formKey.currentState!.validate()) {
      showFeedback(context, 'Por favor, corrija os erros no formulário.',
          error: true);
      return;
    }

    final user = UserRepository.instance.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (user == null) {
      showFeedback(context, 'E-mail/usuário ou senha incorretos.', error: true);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage(user: user)),
    );
  }

  Future<void> _openRegister() async {
    final registered = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
    if (!mounted || registered != true) return;

    showFeedback(context, 'Cadastro realizado! Entre com seus dados.');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo com efeito de brilho
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo_gym.jpg',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: AppColors.purple,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'BANDONI GYM',
                    style: GoogleFonts.aBeeZee(
                      color: AppColors.purple,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 36),
                  AppTextField(
                    controller: _emailController,
                    label: 'E-mail ou Usuário',
                    icon: Icons.person,
                    validator: (value) => Validators.required(
                      value,
                      'Informe o e-mail ou nome de usuário',
                    ),
                  ),
                  const SizedBox(height: 18),
                  PasswordField(
                    controller: _passwordController,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GoldButton(label: 'ENTRAR', onPressed: _login),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Não tem uma conta? ',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: _openRegister,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.padded,
                        ),
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: AppColors.purple,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}