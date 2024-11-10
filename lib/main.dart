import 'dart:async';

import 'package:flutter/material.dart';

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
  int workDuration = 0; // in minutes
  int breakDuration = 0; // in minutes
  Timer? timer;
  bool isWorkMode = false;
  bool isBreakMode = false;
  int remainingWorkMinutes = 0;
  int remainingBreakMinutes = 0;
  Color backgroundColor = Colors.white;

  // For displaying the countdown timer
  String timerText = "";

  TextEditingController workController = TextEditingController();
  TextEditingController breakController = TextEditingController();

  @override
  void dispose() {
    timer?.cancel();
    workController.dispose();
    breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (!isWorkMode && !isBreakMode) ...[
            TextField(
              controller: workController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Установить продолжительность работы (минуты)',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startWorkMode,
              child: Text('Работаем'),
            ),
          ] else if (isWorkMode) ...[
            Text(
              timerText,
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startBreakSetup,
              child: Text('Возьму перерыв'),
            ),
          ] else if (isBreakMode) ...[
            Text(
              timerText,
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            TextField(
              controller: breakController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Установить продолжительность перерыва (минуты)',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startBreakMode,
              child: Text('Отлично, отдыхаем'),
            ),
          ]
        ]),
      )),
    );
  }

  void startWorkMode() {
    if (workController.text.isNotEmpty) {
      setState(() {
        workDuration = int.tryParse(workController.text) ?? 0;
        remainingWorkMinutes = workDuration;
        isWorkMode = true;
        backgroundColor = Colors.yellow; // Indicate work mode is active
        updateTimerText(remainingWorkMinutes);
        startWorkTimer();
      });
    }
  }

  void startWorkTimer() {
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        if (remainingWorkMinutes > 0) {
          remainingWorkMinutes--;
          updateTimerText(remainingWorkMinutes);
        } else {
          timer.cancel();
          // Work duration completed, reset to home screen
          resetToHome();
        }
      });
    });
  }

  void updateTimerText(int minutes) {
    timerText = '$minutes минут${minutes != 1 ? 'ы' : 'а'} осталось';
  }

  void startBreakSetup() {
    timer?.cancel();
    setState(() {
      isWorkMode = false;
      isBreakMode = true;
      backgroundColor = Colors.white;
      // Calculate time until the end of the current hour
      DateTime now = DateTime.now();
      DateTime nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
      Duration difference = nextHour.difference(now);
      remainingBreakMinutes = difference.inMinutes;
      updateTimerText(remainingBreakMinutes);
    });
  }

  void startBreakMode() {
    if (breakController.text.isNotEmpty) {
      setState(() {
        int requestedBreakDuration = int.tryParse(breakController.text) ?? 0;
        DateTime now = DateTime.now();
        DateTime nextHourMinus5 =
            DateTime(now.year, now.month, now.day, now.hour + 1)
                .subtract(Duration(minutes: 5));
        DateTime breakEndTime =
            now.add(Duration(minutes: requestedBreakDuration));
        if (breakEndTime.isAfter(nextHourMinus5)) {
          breakEndTime = nextHourMinus5;
        }
        remainingBreakMinutes = breakEndTime.difference(now).inMinutes;
        backgroundColor = Colors.green; // Indicate break mode is active
        updateTimerText(remainingBreakMinutes);
        startBreakTimer(breakEndTime);
      });
    }
  }

  void startBreakTimer(DateTime breakEndTime) {
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        if (now.isBefore(breakEndTime)) {
          remainingBreakMinutes = breakEndTime.difference(now).inMinutes;
          updateTimerText(remainingBreakMinutes);
        } else {
          timer.cancel();
          // Return to home screen 5 minutes before the next hour
          resetToHome();
        }
      });
    });
  }

  void resetToHome() {
    setState(() {
      isBreakMode = false;
      isWorkMode = false;
      backgroundColor = Colors.white;
      timerText = '';
      workController.clear();
      breakController.clear();
    });
  }
}
