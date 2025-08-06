
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character_model.dart'; // importa modelo
import '../../utils/constants.dart'; // importa constantes

class CharacterService {
  // O método agora vai retornar uma Lista de Characters
  Future<List<Character>> getCharacters() async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.charactersEndpoint);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        // o método .map() para transformar cada item da lista JSON
        // em um objeto Character
        final List<Character> characters = results.map((charJson) {
          return Character.fromJson(charJson);
        }).toList(); 

        return characters;
      } else {
        // Se a resposta não for 200, lança uma exceção
        throw Exception('Falha ao carregar os personagens');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}