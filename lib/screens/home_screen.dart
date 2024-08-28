import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../models/habit.dart';
import '../utils/local_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  double _completionPercentage = 0.0;
  int _streakCount = 0;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    List<Habit> habits = await LocalStorage.loadHabits();
    setState(() {
      _habits = habits;
      _completionPercentage = _calculateCompletionPercentage();
      _streakCount = _calculateStreakCount();
    });
  }

  double _calculateCompletionPercentage() {
    if (_habits.isEmpty) return 0.0;
    int completedHabits = _habits.where((habit) => habit.isCompleted).length;
    return (completedHabits / _habits.length) * 100;
  }

  int _calculateStreakCount() {
    if (_habits.isEmpty) return 0;
    int streakCount = 0;
    for (Habit habit in _habits) {
      streakCount += habit.streakCount;
    }
    return streakCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildDayCountCard(),
                  _buildTodoActionCard(),
                  _buildJournalCard(),
                  Row(
                    children: [
                      Expanded(child: _buildStreakCard()),
                      SizedBox(width: 16),
                      _buildPercentageBar(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildDayCountCard() {
    return Card(
      child: ListTile(
        title: Text('21 days to go'),
      ),
    );
  }

  Widget _buildTodoActionCard() {
    return Card(
      child: ListTile(
        title: Text('Plan your day'),
        trailing: Icon(Icons.check_circle),
        onTap: () {
          Navigator.pushNamed(context, '/todo');
        },
      ),
    );
  }

  Widget _buildJournalCard() {
    return Card(
      child: ListTile(
        title: Text('What\'s on your mind today'),
        trailing: Icon(Icons.lightbulb),
        onTap: () {
          Navigator.pushNamed(context, '/journal');
        },
      ),
    );
  }

  Widget _buildStreakCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_streakCount > 0)
              Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.red),
                  SizedBox(width: 8),
                  Text('$_streakCount Days'),
                ],
              ),
            ..._habits.map((habit) => Text(habit.name)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageBar() {
    return Container(
      width: 40,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: (_completionPercentage / 100) * 160,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Center(
            child: Text(
              '${_completionPercentage.toStringAsFixed(0)}%',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
