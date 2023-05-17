import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Criar uma appbar num ficheiro fora
      appBar: AppBar(
        title: const Text('ReLife'),
      ),
      body: Column(children: [
        // Missões em Destaque
        buildMissoesDestaque(),
        // Missões Normais
        buildMissoesNormais(),
      ]),
    );
  }

  Widget buildMissoesDestaque() {
    return Container(
      height: 10,
      color: Colors.red,
    );
  }

  Widget buildMissoesNormais() {
    return Container(
      height: 10,
      color: Colors.green,
    );
  }
}
