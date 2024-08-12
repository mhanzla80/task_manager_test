import 'package:flutter/material.dart';
import 'package:task_manager_test/models/task_group.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    super.initState();
    // Load saved time
    widget.task.timer.loadElapsedTime(widget.task.id);
  }

  void _updateTime() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.task.timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.task.title),
          Text(widget.task.subtitle),
          Text('Time Spent: ${widget.task.timer.elapsedTime}s'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(widget.task.timer.isRunning
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: () {
                  if (widget.task.timer.isRunning) {
                    widget.task.timer.resumeTimer(() => setState(() {}));
                  } else {
                    widget.task.timer.startTimer(_updateTime);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () {
                  widget.task.timer.stopTimer(() => setState(() {}));
                  // Save the time when stopping
                  widget.task.timer.saveElapsedTime(widget.task.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.restore),
                onPressed: () {
                  widget.task.timer.resetTimer();
                  // Clear saved time
                  widget.task.timer.clearElapsedTime(widget.task.id);
                  setState(() {}); // Update UI
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
