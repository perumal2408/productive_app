import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/local_storage.dart';

class HabitChecklistScreen extends StatefulWidget {
  @override
  _HabitChecklistScreenState createState() => _HabitChecklistScreenState();
}

class _HabitChecklistScreenState extends State<HabitChecklistScreen> {
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    List<Habit> habits = await LocalStorage.loadHabits();
    setState(() {
      _habits = habits;
    });
  }

  void _toggleHabitCompletion(int index) {
    setState(() {
      Habit habit = _habits[index];
      habit.isCompleted = !habit.isCompleted;

      if (habit.isCompleted) {
        habit.streakCount += 1;
      } else if (habit.streakCount > 0) {
        habit.streakCount -= 1;
      }

      _saveHabits();
    });
  }

  Future<void> _saveHabits() async {
    await LocalStorage.saveHabits(_habits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habit Checklist')),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_habits[index].name),
            value: _habits[index].isCompleted,
            onChanged: (bool? value) {
              _toggleHabitCompletion(index);
            },
          );
        },
      ),
    );
  }
}
