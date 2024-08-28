import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import 'dart:convert';

class LocalStorage {
  static Future<void> saveHabits(List<Habit> habits) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = habits.map((habit) => habit.toJson()).toList();
    String jsonString = jsonEncode(jsonList);
    await prefs.setString('habits', jsonString);
  }

  static Future<List<Habit>> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('habits');
    if (jsonString == null) return [];
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Habit.fromJson(json)).toList();
  }

  static Future<void> clearLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Method to clear specific habits data if needed
  static Future<void> clearHabitsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('habits');
  }
}
