import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';

class DetailScreen extends StatelessWidget {
  // A tela vai receber um objeto Character com todos os dados.
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // O título da tela será o nome do personagem.
        title: Text(character.name),
      ),
      body: Center(
        // Por enquanto, só mostramos o nome de novo para confirmar que os dados chegaram.
        child: Text(
          'Detalhes de ${character.name}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}