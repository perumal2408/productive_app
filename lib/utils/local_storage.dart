import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit.dart';

class LocalStorage {
  static Future<void> saveHabits(List<Habit> habits) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habitsJson = habits.map((habit) => jsonEncode(habit.toJson())).toList();
    await prefs.setStringList('habits', habitsJson);
  }

  static Future<List<Habit>> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? habitsJson = prefs.getStringList('habits');
    if (habitsJson != null) {
      return habitsJson.map((json) => Habit.fromJson(jsonDecode(json))).toList();
    }
    return [];
  }
}
