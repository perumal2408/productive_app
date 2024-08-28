import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PercentageBar extends StatelessWidget {
  final double percentage;

  PercentageBar({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width - 64,
        lineHeight: 14.0,
        percent: percentage,
        backgroundColor: Colors.grey[300],
        progressColor: Colors.blue,
        center: Text('${(percentage * 100).toInt()}%'),
      ),
    );
  }
}
