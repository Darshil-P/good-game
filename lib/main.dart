import 'package:flutter/material.dart';
import 'package:goodgame/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Good Game',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple,
        ),
        colorScheme: const ColorScheme.dark(),
      ),
      initialRoute: "/test",
      onGenerateRoute: RouteGenerator.generateRoute,
      // debugShowCheckedModeBanner: false,
    );
  }
}
