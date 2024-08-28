import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/todo_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/habit_checklist_screen.dart';
import 'screens/habit_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(ProductivityApp());
}

class ProductivityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productivity App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/todo': (context) => TodoScreen(),
        '/journal': (context) => JournalScreen(),
        '/habit_checklist': (context) => HabitChecklistScreen(),
        '/hobbies': (context) => HabitScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
