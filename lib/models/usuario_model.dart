class UserModel {
  String name;
  String email;
  String username;
  String password;
  String bio;

  UserModel({
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    this.bio = 'Membro ativo da Bandoni Gym!',
  });
}