import 'package:flutter/material.dart';

class NormalCausesCard extends StatelessWidget {
  final String title;
  final String description;

  const NormalCausesCard(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 200,
      child: Card(
        elevation: 4, //ver qual tem no figma
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Image.network(
            'https://images.impresa.pt/sicnot/2022-12-13-cheias-loures.JPG-e34f562e',
            width: 200,
            height: 150,
            fit: BoxFit.fill,
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
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
