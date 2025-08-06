// lib/data/services/character_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character_model.dart';
import '../../utils/constants.dart';

class CharacterService {
  // O método agora aceita um parâmetro de busca opcional.
  Future<List<Character>> getCharacters({String? name}) async {
    // Começamos com a URL base.
    var urlString = ApiConstants.baseUrl + ApiConstants.charactersEndpoint;

    // Se um nome foi fornecido e não está vazio, adicionamos o parâmetro de query.
    if (name != null && name.isNotEmpty) {
      urlString += '?name=$name';
    }

    final url = Uri.parse(urlString);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        final List<Character> characters = results.map((charJson) {
          return Character.fromJson(charJson);
        }).toList();

        return characters;
      } else if (response.statusCode == 404) {
        // A API retorna 404 se nenhum personagem for encontrado com o nome.
        // Nesse caso, retornamos uma lista vazia.
        return [];
      }
      else {
        throw Exception('Falha ao carregar os personagens');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
