// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:relife/utils/urls.dart';

class FeaturedCausesCard extends StatelessWidget {
  final String title;
  final int amountDonated;
  final int totalAmount;
  final String image;

  const FeaturedCausesCard({
    Key? key,
    required this.title,
    required this.amountDonated,
    required this.totalAmount,
    required this.image,
  });

  double percentageCalculator(int v1, int v2) {
    double value = (v1 / v2).clamp(0, 1);

    return value;
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = percentageCalculator(amountDonated, totalAmount);

    return SizedBox(
      height: 250,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.network(
              '$imageUrl/$image.jpg',
              width: 400,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              height: 10,
              width: 400,
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('$amountDonated €'),
                  const Text(' / '),
                  Text(
                    '$totalAmount €',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              Text('${(progressValue * 100).toStringAsFixed(0)} %'),
            ],
          ),
        ],
      ),
    );
  }
}
