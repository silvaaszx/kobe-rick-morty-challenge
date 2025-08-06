// lib/main.dart

import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/presentation/screens/home_screen.dart'; // Importa nossa futura tela

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData.dark(), // Usaremos um tema escuro como base
      debugShowCheckedModeBanner: false, // Remove a faixa de "Debug"
      home: HomeScreen(), // Define nossa tela principal
    );
  }
}