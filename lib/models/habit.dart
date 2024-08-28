import 'dart:convert';

class Habit {
  final String name;
  bool isCompleted;
  int streakCount;

  Habit({
    required this.name,
    this.isCompleted = false,
    this.streakCount = 0,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      name: json['name'],
      isCompleted: json['isCompleted'] ?? false,  // Provide a default value
      streakCount: json['streakCount'] ?? 0,      // Provide a default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'streakCount': streakCount,
    };
  }
}
