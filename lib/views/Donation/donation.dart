import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        children: const [
          Text('Conteúdo da página de doação'),
        ],
      ),
    );
  }
}
