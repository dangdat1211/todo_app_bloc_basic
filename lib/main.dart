import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/todo-bloc/todo_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Colors.black, 
        onBackground: Colors.white, 
        primary: Colors.orange, 
        onPrimary: Colors.black, 
        secondary: Colors.green, 
        onSecondary: Colors.white, 
      ),
    );

    ThemeData lightTheme = ThemeData(
      brightness: Brightness.light, 
      colorScheme: const ColorScheme.light(
        background: Colors.white,
        onBackground: Colors.black,
        primary: Colors.yellowAccent,
        onPrimary: Colors.black,
        secondary: Colors.lightGreen,
        onSecondary: Colors.white,
      ),
    );

    return MaterialApp(
      title: 'Todo Bloc',
      theme: lightTheme, 
      darkTheme: darkTheme,
      home: BlocProvider<TodoBloc>(
        create: (context) => TodoBloc()..add(TodoStarted()),
        child: const HomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
