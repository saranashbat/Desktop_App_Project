import 'package:flutter/material.dart';

void main() {
  runApp(const PerfumeTestApp());
}

class PerfumeTestApp extends StatelessWidget {
  const PerfumeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfume Image Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Perfume Image Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Lost Cherry',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/perfumes/lost_cherry.jpg',
                width: 200,
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
