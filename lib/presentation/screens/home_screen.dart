// lib/presentation/screens/home_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';
import '../../data/services/character_service.dart';
import '../widgets/character_card.dart';
import '../screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CharacterService _characterService = CharacterService();
  final TextEditingController _searchController = TextEditingController();
  
  // Crio um controller para a lista para saber quando o usuário chega ao fim.
  final ScrollController _scrollController = ScrollController();

  // Novas variáveis para gerir o estado da lista e da paginação.
  List<Character> _characters = [];
  int _currentPage = 1;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true; // Para saber se a API ainda tem mais páginas
  Timer? _debounce; // Para evitar buscas a cada letra digitada

  @override
  void initState() {
    super.initState();
    // Faço a primeira busca de personagens.
    _fetchInitialCharacters();
    // Adiciono um "ouvinte" ao scroll.
    _scrollController.addListener(_onScroll);
  }

  // Este método é chamado sempre que o usuário rola a tela.
  void _onScroll() {
    // Se o usuário chegou ao fim da lista E não estamos a carregar mais itens E ainda há páginas para carregar...
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      // ...então eu busco a próxima página.
      _fetchMoreCharacters();
    }
  }

  // Busca a primeira página de personagens (ou o resultado de uma nova busca).
  Future<void> _fetchInitialCharacters({String? query}) async {
    setState(() {
      _isInitialLoading = true;
      _characters = [];
      _currentPage = 1;
      _hasMore = true;
    });

    try {
      final newCharacters = await _characterService.getCharacters(page: _currentPage, name: query);
      setState(() {
        _characters = newCharacters;
      });
    } catch (e) {
      // Tratar erro se necessário
    } finally {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  // Busca as páginas seguintes e adiciona à lista existente.
  Future<void> _fetchMoreCharacters() async {
    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      final newCharacters = await _characterService.getCharacters(page: _currentPage, name: _searchController.text);
      if (newCharacters.isEmpty) {
        // Se a API não retornar mais personagens, eu sei que cheguei ao fim.
        setState(() {
          _hasMore = false;
        });
      } else {
        setState(() {
          _characters.addAll(newCharacters);
        });
      }
    } catch (e) {
      // Tratar erro
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // Lógica de debounce para a busca.
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchInitialCharacters(query: query);
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Procurar por nome',
                hintText: 'Ex: Rick, Morty, Beth...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _buildCharacterList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterList() {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_characters.isEmpty) {
      return const Center(child: Text('Nenhum personagem encontrado.'));
    }

    // A lista agora tem um item a mais se estivermos a carregar mais.
    return ListView.builder(
      controller: _scrollController,
      itemCount: _characters.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Se o índice for o último item da lista E estamos a carregar mais...
        if (index == _characters.length) {
          // ...eu mostro um indicador de carregamento no fundo.
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final character = _characters[index];
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
