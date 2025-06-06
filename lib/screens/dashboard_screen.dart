import 'package:flutter/material.dart';
import '../widgets/ecg_chart.dart';

class DashboardScreen extends StatelessWidget {
  final String name, age, gender;
  const DashboardScreen({super.key, required this.name, required this.age, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ECG recording App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(title: const Text("Midiendo la frecuencia cardíaca"), subtitle: Text('$name - $age - $gender')),
            ),
            const SizedBox(height: 20),
            const Text('ECG in real time', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Expanded(child: ECGChart()),
            const SizedBox(height: 10),
            const Text('❤️ ALCOM'),
          ],
        ),
      ),
    );
  }
}
