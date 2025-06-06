import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ECGApp());
}

class ECGApp extends StatelessWidget {
  const ECGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG recording App',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
