import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_test/board/board_screen.dart';
import 'package:task_manager_test/helpers/prefs.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';
import 'package:task_manager_test/providers/board_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => BoardProvider(),
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Kanban Board'),
              actions: [
                IconButton(
                  onPressed: () => createTaskGroupInputBottomSheet(
                      context, context.read<BoardProvider>()),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: BoardScreen(provider: context.read<BoardProvider>()),
          );
        },
      ),
    );
  }

  void createTaskGroupInputBottomSheet(
      BuildContext context, BoardProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: BoardGroupInputWidget(provider: provider),
        );
      },
    );
  }
}

class BoardGroupInputWidget extends StatefulWidget {
  final BoardProvider provider;
  const BoardGroupInputWidget({super.key, required this.provider});

  @override
  State<BoardGroupInputWidget> createState() => _BoardGroupInputWidgetState();
}

class _BoardGroupInputWidgetState extends State<BoardGroupInputWidget> {
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
                  widget.provider.controller.addGroup(
                    KanbanGroupData(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text.trim(),
                    ),
                  );
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
