import 'package:flutter/material.dart';

class DayCountCard extends StatelessWidget {
  final int daysRemaining;

  DayCountCard({required this.daysRemaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(
            '$daysRemaining',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text('days to go', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
