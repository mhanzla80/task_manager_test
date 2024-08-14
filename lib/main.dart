import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_test/board/board_screen.dart';
import 'package:task_manager_test/helpers/prefs.dart';
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
            appBar: AppBar(title: const Text('Kanban Board')),
            body: BoardScreen(provider: context.read<BoardProvider>()),
          );
        },
      ),
    );
  }
}
