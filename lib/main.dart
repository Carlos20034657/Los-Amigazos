import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(ECGApp());

class ECGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Simulador 4',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => InicioPage(),
        '/medicion': (context) => MedicionPage(),
      },
    );
  }
}

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulador ECG')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/medicion'),
          child: Text('Comenzar a medir frecuencia cardiaca'),
        ),
      ),
    );
  }
}

class MedicionPage extends StatefulWidget {
  @override
  _MedicionPageState createState() => _MedicionPageState();
}

class _MedicionPageState extends State<MedicionPage> {
  List<FlSpot> _allData = [];
  List<FlSpot> _visibleData = [];
  Timer? _timer;
  int _currentIndex = 0;
  int _speed = 50;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _loadCsvData().then((_) => _startSimulation());
  }

  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString('assets/ecg_data.csv');
    final lines = LineSplitter.split(rawData).skip(2); // skip headers
    _allData = lines.map((line) {
      final parts = line.split(',');
      final x = double.tryParse(parts[0]) ?? 0.0;
      final y = double.tryParse(parts[1]) ?? 0.0;
      return FlSpot(x, y);
    }).toList();
  }

  void _startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _speed), (timer) {
      if (!_isRunning || _currentIndex >= _allData.length) return;
      setState(() {
        _visibleData.add(_allData[_currentIndex]);
        _currentIndex++;
        if (_visibleData.length > 100) {
          _visibleData.removeAt(0);
        }
      });
    });
  }

  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _changeSpeed(int newSpeed) {
    setState(() {
      _speed = newSpeed;
      _startSimulation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medición en tiempo real')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: -1,
                  maxY: 1,
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: false,
                      gradient: LinearGradient(colors: [Colors.red, Colors.red]),
                      barWidth: 2,
                      spots: _visibleData,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _toggleRunning,
                  child: Text(_isRunning ? 'Pausar' : 'Reanudar'),
                ),
                DropdownButton<int>(
                  value: _speed,
                  items: [25, 50, 100, 200].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('${value}ms/pt'),
                    );
                  }).toList(),
                  onChanged: (val) => _changeSpeed(val!),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}