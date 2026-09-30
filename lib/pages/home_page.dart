import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../models/user_repository.dart';
import '../models/workout_model.dart';
import 'login_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final UserModel user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color goldColor = Color(0xFFFFD700);
  late UserModel _user;
  late final List<WorkoutModel> _workouts;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _workouts = UserRepository.instance.workoutsFor(_user);
  }

  Future<void> _addWorkout() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Registrar treino'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Ex.: treino de pernas',
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Informe o treino'
                : null,
            onFieldSubmitted: (_) {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, controller.text.trim());
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCELAR'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, controller.text.trim());
              }
            },
            child: const Text('ADICIONAR'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!mounted || title == null) return;

    setState(() => _workouts.insert(0, WorkoutModel(title: title)));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Treino registrado com sucesso.')),
    );
  }

  Future<void> _openProfile() async {
    final updatedUser = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(user: _user, onLogout: _logout),
      ),
    );
    if (!mounted || updatedUser == null) return;
    setState(() => _user = updatedUser);
  }

  void _logout() {
    UserRepository.instance.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final firstName = _user.name.trim().split(' ').first;
    final completedCount = _workouts
        .where((workout) => workout.isCompleted)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BANDONI GYM',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: _openProfile,
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addWorkout,
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('REGISTRAR TREINO'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BOM TREINO, $firstName',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: goldColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Consistência hoje. Resultado depois.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18181C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.fitness_center, color: goldColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${_workouts.length} treinos registrados',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '$completedCount concluídos',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'MEUS TREINOS',
                    style: TextStyle(
                      color: goldColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _workouts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_note,
                              size: 48,
                              color: Colors.white38,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Nenhum treino registrado ainda.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      itemCount: _workouts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final workout = _workouts[index];
                        return Card(
                          color: const Color(0xFF18181C),
                          child: ListTile(
                            leading: Checkbox(
                              value: workout.isCompleted,
                              activeColor: goldColor,
                              onChanged: (value) => setState(
                                () => workout.isCompleted = value ?? false,
                              ),
                            ),
                            title: Text(
                              workout.title,
                              style: TextStyle(
                                decoration: workout.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(_formatDate(workout.createdAt)),
                            trailing: IconButton(
                              tooltip: 'Remover treino',
                              onPressed: () =>
                                  setState(() => _workouts.removeAt(index)),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
