import 'package:flutter/material.dart';
import 'package:task_manager_test/models/task_group.dart';
import 'package:task_manager_test/providers/board_provider.dart';

class CreateTaskCardWidget extends StatefulWidget {
  final BoardProvider provider;
  final String groupId;
  const CreateTaskCardWidget(
      {super.key, required this.provider, required this.groupId});

  @override
  State<CreateTaskCardWidget> createState() => _CreateTaskCardWidgetState();
}

class _CreateTaskCardWidgetState extends State<CreateTaskCardWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _descController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              'Create New Task',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),
            TextFormField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Task Name (Fix Bug)...',
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter Task Description...',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _nameController.text.isNotEmpty) {
                  final task = Task(
                      title: _nameController.text.trim(),
                      subtitle: _descController.text.trim());
                  widget.provider.controller.addGroupItem(widget.groupId, task);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            )
          ],
        ),
      ),
    );
  }
}
