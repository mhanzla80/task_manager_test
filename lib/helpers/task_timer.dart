import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager_test/helpers/prefs.dart';

class TaskTimer {
  late String id;
  Timer? _timer;

  // Time in seconds
  int _elapsedTime = 0;
  bool _isRunning = false;

  TaskTimer(String title) {
    id = title;
    loadElapsedTime(id);
  }

  int get elapsedTime => _elapsedTime;
  bool get isRunning => _isRunning;

  void startTimer(VoidCallback updateCallback) {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedTime += 1;
        saveElapsedTime(id);
        // Update the UI
        updateCallback.call();
      });
    }
  }

  void stopTimer(VoidCallback updateCallback) {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel();
      updateCallback.call();
    }
  }

  void resetTimer() {
    // _stopwatch.reset();
    _elapsedTime = 0;
    _isRunning = false;
  }

  void resumeTimer(VoidCallback updateCallback) {
    if (!_isRunning && _elapsedTime > 0) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedTime += 1;
        saveElapsedTime(id);
        updateCallback.call();
      });
    }
  }

  void loadElapsedTime(String taskId) {
    final savedTime = Prefs.instance.loadElapsedTime(taskId) ?? 0;
    _elapsedTime = savedTime;
  }

  void saveElapsedTime(String taskId) {
    Prefs.instance.saveElapsedTime(taskId, _elapsedTime);
  }

  void clearElapsedTime(String taskId) {
    Prefs.instance.clearElapsedTime(taskId);
    _elapsedTime = 0;
  }

  void dispose() {
    _timer?.cancel();
  }
}
