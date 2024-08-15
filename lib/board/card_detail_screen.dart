import 'package:flutter/material.dart';
import 'package:task_manager_test/models/task_group.dart';
import 'package:task_manager_test/providers/board_provider.dart';

class CardDetailScreen extends StatefulWidget {
  final BoardProvider provider;
  final String groupId;
  final Task task;
  const CardDetailScreen({
    super.key,
    required this.task,
    required this.provider,
    required this.groupId,
  });

  @override
  State<CardDetailScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<CardDetailScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _commentController;
  List<String> comments = [];

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.subtitle);
    _commentController = TextEditingController();
    comments.addAll(widget.task.comments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            onPressed: () {
              widget.task.title = _nameController.text.trim();
              widget.task.subtitle = _descController.text.trim();
              widget.provider.updateGroupItem(widget.groupId, widget.task);
              Navigator.pop(context, true);
              return;
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          TextFormField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: _nameController,
            decoration: const InputDecoration(label: Text('Title')),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: _descController,
            decoration: const InputDecoration(label: Text('Description')),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  controller: _commentController,
                  decoration: InputDecoration(
                    label: const Text('Add Comment'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          comments.add(_commentController.text.trim());
                          _commentController.clear();
                          widget.task.comments = comments;
                          widget.provider
                              .updateGroupItem(widget.groupId, widget.task);
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ...comments.reversed.map((e) => Text(e)),
        ],
      ),
    );
  }
}
