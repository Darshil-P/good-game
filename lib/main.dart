import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goodgame/router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  // This is required to Initialize Firebase Before MyApp()
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // MyApp Should be created after Firebase is Initialized to Check for Signed-In User
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
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      // debugShowCheckedModeBanner: false,
    );
  }
}
