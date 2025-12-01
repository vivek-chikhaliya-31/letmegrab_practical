import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_practical/provider/todo_provider.dart';
import 'package:todo_practical/screen/todo_list_page.dart';
import 'package:todo_practical/service/database_helper.dart'; // import your provider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize database
  await DBHelper.instance.database;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TodoProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoListPage(),
    );
  }
}
