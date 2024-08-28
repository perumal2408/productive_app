import 'package:flutter/material.dart';

class TodoActionCard extends StatelessWidget {
  final VoidCallback onTap;

  TodoActionCard({required this.onTap});

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Plan your day', style: TextStyle(fontSize: 18)),
            Icon(Icons.check_circle_outline),
          ],
        ),
      ),
    );
  }
}
