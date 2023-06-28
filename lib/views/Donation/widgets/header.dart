import 'package:flutter/material.dart';
import 'package:relife/utils/constants.dart';

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
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 10,
            width: 342,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
