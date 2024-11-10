import 'package:flutter/material.dart';

import 'timer_logic.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Timer App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TimerApp());
  }
}

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  final TimerLogic timerLogic = TimerLogic();

  final TextEditingController workController = TextEditingController();
  final TextEditingController breakController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timerLogic.addListener(_updateUI);
  }

  @override
  void dispose() {
    timerLogic.removeListener(_updateUI);
    timerLogic.dispose();
    workController.dispose();
    breakController.dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {}); // Rebuild the UI when notified
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: timerLogic.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!timerLogic.isWorkMode && !timerLogic.isBreakMode) ...[
                TextField(
                  controller: workController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Установить продолжительность работы (минуты)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    timerLogic.startWorkMode(workController.text);
                  },
                  child: Text('Работаем'),
                ),
              ] else if (timerLogic.isWorkMode) ...[
                Text(
                  timerLogic.timerText,
                  style: TextStyle(fontSize: 48),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: timerLogic.startBreakSetup,
                  child: Text('Возьму перерыв'),
                ),
              ] else if (timerLogic.isBreakMode) ...[
                Text(
                  timerLogic.timerText,
                  style: TextStyle(fontSize: 48),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: breakController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Установить продолжительность перерыва (минуты)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    timerLogic.startBreakMode(breakController.text);
                  },
                  child: Text('Отлично, отдыхаем'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
