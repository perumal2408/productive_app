import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final VoidCallback onTap;

  StreakCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          children: List.generate(5, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Streak', style: TextStyle(fontSize: 18)),
                Text('${index * 3 + 3}', style: TextStyle(fontSize: 16)),
                Icon(Icons.local_fire_department),
              ],
            );
          }),
        ),
      ),
    );
  }
}
