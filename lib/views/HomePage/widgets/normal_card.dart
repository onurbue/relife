import 'package:flutter/material.dart';

class NormalCausesCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const NormalCausesCard(
      {super.key,
      required this.title,
      required this.description,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 200,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/images/missions/$image',
              width: 200,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
