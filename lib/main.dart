

import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/presentation/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // O app agora começa na MainScreen, que controla o menu e as outras telas.
      home: const MainScreen(),
    );
  }
}
