// lib/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';
import '../../data/services/character_service.dart';

// Importa o widget que criei para exibir os personagens
import '../widgets/character_card.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Criamos uma instância do nosso serviço
  final CharacterService _characterService = CharacterService();
  // Criamos uma variável para armazenar o "futuro" resultado da nossa chamada de API
  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    // Assim que a tela é iniciada, chamamos o método para buscar os personagens
    _charactersFuture = _characterService.getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Character>>(
        // O FutureBuilder vai "escutar" o resultado do _charactersFuture
        future: _charactersFuture,
        // O builder é a função que constrói a tela baseada no estado do Future
        builder: (context, snapshot) {
          // CASO 1: Enquanto os dados estão carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // CASO 2: Se ocorreu um erro na chamada da API
          else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados: ${snapshot.error}'));
          }
          // CASO 3: Se os dados foram carregados com sucesso
else if (snapshot.hasData) {
  final characters = snapshot.data!;
  // Construímos a lista
  return ListView.builder(
    itemCount: characters.length,
    itemBuilder: (context, index) {
      final character = characters[index];
      return CharacterCard(character: character);
    },
  );
}
          // CASO 4: Estado inicial ou sem dados (não deve acontecer com FutureBuilder)
          else {
            return const Center(child: Text('Nenhum personagem encontrado.'));
          }
        },
      ),
    );
  }
}