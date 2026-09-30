class WorkoutModel {
  final String title;
  final DateTime createdAt;
  bool isCompleted;

  WorkoutModel({
    required this.title,
    DateTime? createdAt,
    this.isCompleted = false,
  }) : createdAt = createdAt ?? DateTime.now();
}
