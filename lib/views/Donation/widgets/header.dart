import 'package:flutter/material.dart';

class CustomBarHeader extends StatelessWidget {
  final String title;
  final double percentage;

  const CustomBarHeader({
    super.key,
    required this.percentage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 10,
            width: 400,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ),
      ],
    );
  }
}
