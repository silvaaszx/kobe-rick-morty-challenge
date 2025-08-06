// lib/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';
import '../../data/services/character_service.dart';
import '../widgets/character_card.dart';
import '../screens/detail_screen.dart'; // Import da tela de detalhes

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CharacterService _characterService = CharacterService();
  late Future<List<Character>> _charactersFuture;

  // Crio um controller para o campo de texto, para poder ler o que o usuário digita.
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // A busca inicial carrega todos os personagens.
    _fetchCharacters();
  }

  // Criei um método para a busca, para poder chamá-lo de vários lugares.
  void _fetchCharacters({String? query}) {
    setState(() {
      _charactersFuture = _characterService.getCharacters(name: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Meu campo de busca
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nome',
                hintText: 'Ex: Rick, Morty, Beth...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // A cada mudança no texto, eu chamo a busca.
              onChanged: (value) {
                _fetchCharacters(query: value);
              },
            ),
          ),
          // O Expanded garante que a lista ocupe o resto da tela.
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final characters = snapshot.data!;
                  return ListView.builder(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      // Adiciono o clique para navegar
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(character: character),
                            ),
                          );
                        },
                        child: CharacterCard(character: character),
                      );
                    },
                  );
                } else {
                  // Mensagem para quando a busca não retorna nada.
                  return const Center(child: Text('Nenhum personagem encontrado.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Lembro de limpar o controller quando a tela for destruída.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
