import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class ConsentScreen extends StatefulWidget {
  final String name, age, gender;
  const ConsentScreen({super.key, required this.name, required this.age, required this.gender});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool acceptedTerms = false;
  bool shareECG = false;
  bool receiveNotifications = false;

  void _startECG() {
    if (acceptedTerms) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            name: widget.name,
            age: widget.age,
            gender: widget.gender,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes aceptar los términos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido ${widget.name}, gracias por utilizar la app "ECG recording App"', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Antes de continuar por favor acepta lo siguiente:', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Términos y condiciones'),
              value: acceptedTerms,
              onChanged: (val) => setState(() => acceptedTerms = val!),
            ),
            CheckboxListTile(
              title: const Text('Acepto compartir mi información del ECG para su análisis'),
              value: shareECG,
              onChanged: (val) => setState(() => shareECG = val!),
            ),
            CheckboxListTile(
              title: const Text('Acepto recibir notificaciones sobre mis resultados'),
              value: receiveNotifications,
              onChanged: (val) => setState(() => receiveNotifications = val!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _startECG, child: const Text('Comenzar la adquisición de ECG'))
          ],
        ),
      ),
    );
  }
}
