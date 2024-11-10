import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerLogic extends ChangeNotifier {
  int defaultWorkDuration = 45; // Default in seconds for testing
  int workDuration = 0; // in seconds
  int breakDuration = 0; // in seconds
  Timer? timer;
  bool isWorkMode = false;
  bool isBreakMode = false;
  int remainingWorkSeconds = 0; // Working seconds left
  int remainingBreakSeconds = 0; // Break seconds left
  Color backgroundColor = Colors.white;

  String timerText = "";
  String workStatusText = "";

  TimerLogic() {
    loadDefaultWorkDuration();
  }

  // Load default work duration from storage
  Future<void> loadDefaultWorkDuration() async {
    final prefs = await SharedPreferences.getInstance();
    defaultWorkDuration = prefs.getInt('defaultWorkDuration') ?? 45;
    workDuration = defaultWorkDuration;
    notifyListeners();
  }

  // Save default work duration to storage
  Future<void> setDefaultWorkDuration(int seconds) async {
    defaultWorkDuration = seconds;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('defaultWorkDuration', seconds);
    notifyListeners();
  }

  void startWorkMode(String durationText) {
    if (durationText.isNotEmpty) {
      workDuration = int.tryParse(durationText) ?? defaultWorkDuration;
      remainingWorkSeconds = workDuration;
      isWorkMode = true;
      backgroundColor = Colors.yellow;
      workStatusText = "Поработал 0 из $workDuration секунд запланированных";
      updateTimerText(remainingWorkSeconds);
      startWorkTimer();
      notifyListeners();
    }
  }

  void startWorkTimer() {
    timer?.cancel();
    int workedSeconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingWorkSeconds > 0) {
        remainingWorkSeconds--;
        workedSeconds++;
        workStatusText =
            "Поработал $workedSeconds из $workDuration секунд запланированных";
        updateTimerText(remainingWorkSeconds);
        notifyListeners();
      } else {
        timer.cancel();
        startBreakSetup();
      }
    });
  }

  // void startBreakSetup() {
  //   timer?.cancel();
  //   isWorkMode = false;
  //   isBreakMode = true;
  //   backgroundColor = Colors.green;
  //
  //   // Calculate seconds until the next hour
  //   DateTime now = DateTime.now();
  //   // int secondsUntilNextHour = (60 - now.minute) * 60 - now.second;
  //   int secondsUntilNextHour = (60 - now.minute) * 60 - now.second;
  //   remainingBreakSeconds = secondsUntilNextHour;
  //
  //   updateBreakTimerText();
  //   startBreakTimer();
  //   notifyListeners();
  // }
  //
  // void startBreakTimer() {
  //   timer?.cancel();
  //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (remainingBreakSeconds > 0) {
  //       remainingBreakSeconds--;
  //       updateBreakTimerText();
  //       notifyListeners();
  //     } else {
  //       timer.cancel();
  //       resetToHome();
  //     }
  //   });
  // }

  void startBreakSetup() {
    timer?.cancel();
    isWorkMode = false;
    isBreakMode = true;
    backgroundColor = Colors.green;

    // Calculate seconds until the start of the next minute
    DateTime now = DateTime.now();
    int secondsUntilNextMinute = 60 - now.second;
    remainingBreakSeconds = secondsUntilNextMinute;

    updateBreakTimerText();
    startBreakTimer();
    notifyListeners();
  }

  void startBreakTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingBreakSeconds > 0) {
        remainingBreakSeconds--;
        updateBreakTimerText();
        notifyListeners();
      } else {
        timer.cancel();
        resetToHome();
      }
    });
  }

  void updateTimerText(int seconds) {
    timerText = '$seconds секунд осталось';
  }

  void updateBreakTimerText() {
    timerText =
        'Отдыхать еще ${remainingBreakSeconds} секунд до начала следующей минуты';
  }

  void resetToHome() {
    timer?.cancel();
    isWorkMode = false;
    isBreakMode = false;
    backgroundColor = Colors.white;
    workDuration = defaultWorkDuration;
    remainingWorkSeconds = workDuration;
    timerText = '';
    workStatusText = '';
    notifyListeners();
  }
}
