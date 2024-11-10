import 'package:flutter/material.dart';

import 'timer_logic.dart';
import 'widgets/action_button.dart';
import 'widgets/minute_input_field.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Рабочий таймер',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerApp(),
    );
  }
}

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  final TimerLogic timerLogic = TimerLogic();

  final TextEditingController workController = TextEditingController();
  final TextEditingController breakController = TextEditingController();
  final TextEditingController defaultTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timerLogic.addListener(_updateUI);
    defaultTimeController.text = timerLogic.defaultWorkDuration.toString();
  }

  @override
  void dispose() {
    timerLogic.removeListener(_updateUI);
    timerLogic.dispose();
    workController.dispose();
    breakController.dispose();
    defaultTimeController.dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {
      workController.text = timerLogic.workDuration.toString();
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Настройки"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Время работы по умолчанию"),
              TextField(
                controller: defaultTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(suffixText: "секунд"),
                onChanged: (value) {
                  final newDefaultTime =
                      int.tryParse(value) ?? timerLogic.defaultWorkDuration;
                  timerLogic.setDefaultWorkDuration(newDefaultTime);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Закрыть"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Рабочий таймер"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      backgroundColor: timerLogic.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timerLogic.workStatusText.isEmpty
                    ? "Время работы: ${timerLogic.workDuration} секунд"
                    : timerLogic.workStatusText,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              MinuteInputField(
                controller: workController,
                fontSize: 48,
              ),
              SizedBox(height: 20),
              Text(
                timerLogic.timerText,
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(height: 20),
              ActionButton(
                text: timerLogic.isWorkMode
                    ? "Дайте передышку"
                    : timerLogic.isBreakMode
                        ? "Отлично отдыхаем!"
                        : "Работаем",
                onPressed: () {
                  if (timerLogic.isWorkMode) {
                    timerLogic.startBreakSetup();
                  } else if (timerLogic.isBreakMode) {
                    // Do nothing or show a message
                  } else {
                    timerLogic.startWorkMode(workController.text);
                  }
                },
                fontSize: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
