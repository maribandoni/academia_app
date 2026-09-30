import 'usuario_model.dart';
import 'workout_model.dart';

class UserRepository {
  UserRepository._();

  static final UserRepository instance = UserRepository._();

  final List<UserModel> _users = [];
  final Map<String, List<WorkoutModel>> _workoutsByEmail = {};
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool register(UserModel user) {
    final email = user.email.trim().toLowerCase();
    final username = user.username.trim().toLowerCase();
    final alreadyRegistered = _users.any(
      (registeredUser) =>
          registeredUser.email.toLowerCase() == email ||
          registeredUser.username.toLowerCase() == username,
    );
    if (alreadyRegistered) return false;

    _users.add(user);
    _workoutsByEmail[email] = [];
    return true;
  }

  UserModel? login(String identifier, String password) {
    _currentUser = null;
    final normalizedIdentifier = identifier.trim().toLowerCase();
    for (final user in _users) {
      final matchesIdentifier =
          user.email.toLowerCase() == normalizedIdentifier ||
          user.username.toLowerCase() == normalizedIdentifier;
      if (matchesIdentifier && user.password == password) {
        _currentUser = user;
        return user;
      }
    }
    return null;
  }

  bool updateProfile({
    required UserModel user,
    required String name,
    required String username,
    required String bio,
  }) {
    final normalizedUsername = username.trim().toLowerCase();
    final usernameInUse = _users.any(
      (registeredUser) =>
          !identical(registeredUser, user) &&
          registeredUser.username.toLowerCase() == normalizedUsername,
    );
    if (usernameInUse) return false;

    user.name = name.trim();
    user.username = username.trim();
    user.bio = bio.trim();
    return true;
  }

  List<WorkoutModel> workoutsFor(UserModel user) =>
      _workoutsByEmail.putIfAbsent(user.email.toLowerCase(), () => []);

  void logout() {
    _currentUser = null;
  }
}
