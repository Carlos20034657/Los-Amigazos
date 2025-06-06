import 'dart:async';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ECGChart extends StatefulWidget {
  const ECGChart({super.key});

  @override
  State<ECGChart> createState() => _ECGChartState();
}

class _ECGChartState extends State<ECGChart> {
  List<FlSpot> _allData = [];
  List<FlSpot> _visibleData = [];
  Timer? _timer;
  int _currentIndex = 0;
  int _speed = 50; // ms por punto
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _loadCsvData().then((_) => _startSimulation());
  }

  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString('assets/ecg_data.csv');
    final lines = LineSplitter.split(rawData).skip(0); // Cambia a skip(2) si tienes encabezados
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
          _visibleData.removeAt(0); // Desplaza para mantener 100 puntos visibles
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
      _startSimulation(); // Reinicia el timer con la nueva velocidad
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  color: Colors.red,
                  barWidth: 2,
                  spots: _visibleData,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
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
                  child: Text('$value ms/punto'),
                );
              }).toList(),
              onChanged: (val) => _changeSpeed(val!),
            ),
          ],
        ),
      ],
    );
  }
}
