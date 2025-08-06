import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character_model.dart';
import '../../utils/constants.dart';

class CharacterService {
  // O método agora aceita um parâmetro de busca e um de página.
  Future<List<Character>> getCharacters({String? name, int page = 1}) async {
    // Usamos Uri.https para construir a URL de forma mais segura e fácil.
    // O primeiro argumento é a autoridade (o domínio), o segundo é o caminho.
    // O terceiro é um Map com os parâmetros de query.
    final uri = Uri.https(
      'rickandmortyapi.com', // Autoridade
      '/api/character',      // Caminho
      <String, String>{
        'page': page.toString(),
        if (name != null && name.isNotEmpty) 'name': name,
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? []; // Usamos ?? [] para segurança

        final List<Character> characters = results.map((charJson) {
          return Character.fromJson(charJson);
        }).toList();

        return characters;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Falha ao carregar os personagens');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
