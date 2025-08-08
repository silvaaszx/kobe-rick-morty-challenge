// lib/presentation/screens/home_screen.dart

import '../widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final ScrollController _scrollController = ScrollController();

  List<Character> _characters = [];
  int _currentPage = 1;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchInitialCharacters();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      _fetchMoreCharacters();
    }
  }

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
      // Tratar erro
    } finally {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _fetchMoreCharacters() async {
    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      final newCharacters = await _characterService.getCharacters(page: _currentPage, name: _searchController.text);
      if (newCharacters.isEmpty) {
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchInitialCharacters(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AQUI ESTÁ O AJUSTE FINAL
      appBar:const CustomAppBar(),
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

    return ListView.builder(
      controller: _scrollController,
      itemCount: _characters.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _characters.length) {
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
