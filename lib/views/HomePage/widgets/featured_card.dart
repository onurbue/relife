import 'package:flutter/material.dart';

class FeaturedCausesCard extends StatelessWidget {
  final String title;
  final int amountDonated;
  final int totalAmount;

  const FeaturedCausesCard({
    Key? key,
    required this.title,
    required this.amountDonated,
    required this.totalAmount,
  });

  int percentageCalculator(int v1, int v2) {
    double value = (v1 / v2) * 100;
    return value.round();
  }

  @override
  Widget build(BuildContext context) {
//Testes
    int v = percentageCalculator(amountDonated, totalAmount);
    String vv = '0.$v';
    double vvv = double.parse(vv);

    print(v);
    print(vv);
    print(vvv);
//Testes

    return SizedBox(
      height: 250,
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://static.mundoeducacao.uol.com.br/mundoeducacao/conteudo_legenda/092c05b38cb5fb3340de31b92577e54c.jpg',
              width: 400,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
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
                value: vvv,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
              Text(
                  '${percentageCalculator(amountDonated, totalAmount).toString()} %'),
            ],
          )
        ],
      ),
    );
  }
}
