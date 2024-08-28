import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/local_storage.dart';

class HabitScreen extends StatefulWidget {
  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final List<Habit> _habits = [];
  final TextEditingController _controller = TextEditingController();

  void _addHabit(String name) {
    if (_habits.length < 7) {
      setState(() {
        _habits.add(Habit(name: name));
      });
      _controller.clear();
    }
  }

  Future<void> _saveHabits() async {
    await LocalStorage.saveHabits(_habits);
  }

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    List<Habit> habits = await LocalStorage.loadHabits();
    setState(() {
      _habits.addAll(habits);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Habits'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter Habit',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _addHabit(_controller.text);
                  _saveHabits();
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_habits[index].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
