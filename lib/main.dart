// main.dart

import 'package:flutter/material.dart';

import 'timer_logic.dart';
import 'widgets/action_button.dart';
import 'widgets/countdown_text.dart';
import 'widgets/minute_input_field.dart';

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
    setState(() {}); // Перерисовка UI при уведомлении
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: timerLogic.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildContent(),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (!timerLogic.isWorkMode && !timerLogic.isBreakMode) {
      // Начальный экран
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MinuteInputField(
            controller: workController,
          ),
          SizedBox(width: 10),
          ActionButton(
            text: 'Работаем',
            onPressed: () {
              timerLogic.startWorkMode(workController.text);
            },
          ),
        ],
      );
    } else if (timerLogic.isWorkMode) {
      // Экран режима работы
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CountdownText(
            text: timerLogic.timerText,
          ),
          SizedBox(height: 20),
          ActionButton(
            text: 'Возьму перерыв',
            onPressed: timerLogic.startBreakSetup,
          ),
        ],
      );
    } else if (timerLogic.isBreakMode) {
      // Экран режима перерыва
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CountdownText(
            text: timerLogic.timerText,
          ),
          SizedBox(height: 20),
          MinuteInputField(
            controller: breakController,
          ),
          SizedBox(height: 20),
          ActionButton(
            text: 'Отлично, отдыхаем',
            onPressed: () {
              timerLogic.startBreakMode(breakController.text);
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
