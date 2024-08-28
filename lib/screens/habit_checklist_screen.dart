import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitChecklistScreen extends StatefulWidget {
  @override
  _HabitChecklistScreenState createState() => _HabitChecklistScreenState();
}

class _HabitChecklistScreenState extends State<HabitChecklistScreen> {
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  Future<void> _loadHobbies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hobbies = prefs.getStringList('hobbies') ?? [];
    setState(() {
      _habits = hobbies.map((hobby) => Habit(name: hobby, completed: false)).toList();
    });
  }

  void _toggleHabitCompletion(int index) {
    setState(() {
      _habits[index].completed = !_habits[index].completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habit Checklist')),
      body: _habits.isEmpty
          ? Center(child: Text('No habits added yet'))
          : ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_habits[index].name),
                  value: _habits[index].completed,
                  onChanged: (bool? value) {
                    _toggleHabitCompletion(index);
                  },
                );
              },
            ),
    );
  }
}

class Habit {
  String name;
  bool completed;

  Habit({required this.name, this.completed = false});
}
