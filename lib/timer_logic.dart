// timer_logic.dart

import 'dart:async';

import 'package:flutter/material.dart';

class TimerLogic extends ChangeNotifier {
  int workDuration = 0; // in minutes
  int breakDuration = 0; // in minutes
  Timer? timer;
  bool isWorkMode = false;
  bool isBreakMode = false;
  int remainingWorkMinutes = 0;
  int remainingBreakMinutes = 0;
  Color backgroundColor = Colors.white;

  String timerText = "";

  void startWorkMode(String durationText) {
    if (durationText.isNotEmpty) {
      workDuration = int.tryParse(durationText) ?? 0;
      remainingWorkMinutes = workDuration;
      isWorkMode = true;
      backgroundColor = Colors.yellow; // Indicate work mode is active
      updateTimerText(remainingWorkMinutes);
      startWorkTimer();
      notifyListeners();
    }
  }

  void startWorkTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (remainingWorkMinutes > 0) {
        remainingWorkMinutes--;
        updateTimerText(remainingWorkMinutes);
        notifyListeners();
      } else {
        timer.cancel();
        resetToHome();
      }
    });
  }

  void updateTimerText(int minutes) {
    timerText =
        '$minutes минут${(minutes % 10 == 1 && minutes != 11) ? 'а' : (minutes % 10 >= 2 && minutes % 10 <= 4 && (minutes < 12 || minutes > 14)) ? 'ы' : ''} осталось';
  }

  void startBreakSetup() {
    timer?.cancel();
    isWorkMode = false;
    isBreakMode = true;
    backgroundColor = Colors.white;
    // Calculate time until the end of the current hour
    DateTime now = DateTime.now();
    DateTime nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    Duration difference = nextHour.difference(now);
    remainingBreakMinutes = difference.inMinutes;
    updateTimerText(remainingBreakMinutes);
    notifyListeners();
  }

  void startBreakMode(String durationText) {
    if (durationText.isNotEmpty) {
      int requestedBreakDuration = int.tryParse(durationText) ?? 0;
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
      notifyListeners();
    }
  }

  void startBreakTimer(DateTime breakEndTime) {
    timer?.cancel();
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.isBefore(breakEndTime)) {
        remainingBreakMinutes = breakEndTime.difference(now).inMinutes;
        updateTimerText(remainingBreakMinutes);
        notifyListeners();
      } else {
        timer.cancel();
        resetToHome();
      }
    });
  }

  void resetToHome() {
    timer?.cancel();
    isBreakMode = false;
    isWorkMode = false;
    backgroundColor = Colors.white;
    timerText = '';
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
