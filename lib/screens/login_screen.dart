import 'package:flutter/material.dart';
import 'consent_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsentScreen(
          name: _nameController.text,
          age: _ageController.text,
          gender: _genderController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ECG recording App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Por favor ingresa tus datos:', style: TextStyle(fontSize: 16)),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Edad')),
            TextField(controller: _genderController, decoration: const InputDecoration(labelText: 'Género')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _continue, child: const Text('Continue'))
          ],
        ),
      ),
    );
  }
}
