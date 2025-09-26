import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  // Fetch characters
  Future<CharactersResponse> getCharacters({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/character/?page=$page'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CharactersResponse.fromJson(data);
      } else {
        throw Exception('Failed to load characters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Search characters by name
  Future<CharactersResponse> searchCharacters(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/character/?name=$name'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CharactersResponse.fromJson(data);
      } else {
        throw Exception('No characters found');
      }
    } catch (e) {
      throw Exception('Search error: ${e.toString()}');
    }
  }
}