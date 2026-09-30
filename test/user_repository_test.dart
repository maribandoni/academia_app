import 'package:academia_app/models/user_repository.dart';
import 'package:academia_app/models/usuario_model.dart';
import 'package:academia_app/models/workout_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supports registration, login, profile updates, workouts, and logout', () {
    final repository = UserRepository.instance;
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final user = UserModel(
      name: 'Alex Silva',
      email: 'alex$suffix@example.com',
      username: 'alex$suffix',
      password: 'strongpass',
    );

    expect(repository.register(user), isTrue);
    expect(
      repository.register(
        UserModel(
          name: 'Another Alex',
          email: user.email.toUpperCase(),
          username: 'another$suffix',
          password: 'strongpass',
        ),
      ),
      isFalse,
    );

    expect(repository.login(user.email, 'incorrect'), isNull);
    expect(repository.currentUser, isNull);
    expect(repository.login(user.username, user.password), same(user));
    expect(repository.currentUser, same(user));

    expect(
      repository.updateProfile(
        user: user,
        name: 'Alex Santos',
        username: 'alex-santos$suffix',
        bio: 'Treino de força',
      ),
      isTrue,
    );
    expect(user.name, 'Alex Santos');
    expect(user.bio, 'Treino de força');

    repository.workoutsFor(user).add(WorkoutModel(title: 'Treino de pernas'));
    expect(repository.workoutsFor(user), hasLength(1));

    repository.logout();
    expect(repository.currentUser, isNull);
  });
}
