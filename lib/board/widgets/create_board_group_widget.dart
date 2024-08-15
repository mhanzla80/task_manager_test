import 'package:flutter/material.dart';
import 'package:task_manager_test/providers/board_provider.dart';

class CreateBoardGroupWidget extends StatefulWidget {
  final BoardProvider provider;
  const CreateBoardGroupWidget({super.key, required this.provider});

  @override
  State<CreateBoardGroupWidget> createState() => _CreateBoardGroupWidgetState();
}

class _CreateBoardGroupWidgetState extends State<CreateBoardGroupWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
              'Create Task Group',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),
            TextFormField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Group Name (To Do)...',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _nameController.text.isNotEmpty) {
                  widget.provider.addGroup(_nameController.text.trim());
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
