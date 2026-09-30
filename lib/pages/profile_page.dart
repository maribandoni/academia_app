import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import 'edit_profile_page.dart';
import '../theme/app_colors.dart';
import '../utils/feedback.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user, required this.onLogout});

  final UserModel user;
  final VoidCallback onLogout;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _editProfile() async {
    final updatedUser = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(user: _user)),
    );
    if (!mounted || updatedUser == null) return;
    setState(() => _user = updatedUser);
    showFeedback(context, 'Dados atualizados com sucesso.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: () => Navigator.pop(context, _user),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('MEU PERFIL'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 12),
            const Center(
              child: CircleAvatar(
                radius: 58,
                backgroundColor: AppColors.purple,
                backgroundImage: AssetImage('assets/logo_gym.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _user.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                '@${_user.username}',
                style: const TextStyle(color: AppColors.purple, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SOBRE MIM',
                    style: TextStyle(
                      color: AppColors.purple,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user.bio.isEmpty ? 'Adicione uma descrição.' : _user.bio,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'E-MAIL',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(_user.email),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('EDITAR PERFIL'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}