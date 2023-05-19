import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relife/widgets/appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Featured Causes',
            style: GoogleFonts.workSans(
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),

          // Missões em Destaque
          buildMissoesDestaque(),

          const SizedBox(height: 20),
          Text(
            'Causes',
            style: GoogleFonts.workSans(
                textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),

          // Missões Normais
          buildMissoesNormais(),
        ]),
      ),
      // Barra de navegação
      bottomNavigationBar: null,
    );
  }

  Widget buildMissoesDestaque() {
    return Container(
        width: 10,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: const BoxDecoration(color: Colors.amber),
        child: const Text(
          'text 2',
          style: TextStyle(fontSize: 16.0),
        ));
  }

  Widget buildMissoesNormais() {
    return Container(
        width: 10,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: const BoxDecoration(color: Colors.amber),
        child: const Text(
          'text 2',
          style: TextStyle(fontSize: 16.0),
        ));
  }
}
