import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../models/character_model.dart';
import 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final ApiService _apiService;
  List<Character> _characters = [];
  int _currentPage = 1;

  CharactersCubit(this._apiService) : super(CharactersInitial());

  // Load characters
  Future<void> loadCharacters() async {
    try {
      emit(CharactersLoading());
      final response = await _apiService.getCharacters(page: 1);
      _characters = response.results;
      _currentPage = 1;
      emit(CharactersLoaded(
        characters: _characters,
        hasMore: _currentPage < response.pages,
      ));
    } catch (e) {
      emit(CharactersError(message: e.toString()));
    }
  }

  // Load more characters (pagination)
  Future<void> loadMoreCharacters() async {
    if (state is CharactersLoaded) {
      try {
        final response = await _apiService.getCharacters(page: _currentPage + 1);
        _characters.addAll(response.results);
        _currentPage++;
        emit(CharactersLoaded(
          characters: _characters,
          hasMore: _currentPage < response.pages,
        ));
      } catch (e) {
        // Handle error silently for pagination
      }
    }
  }

  // Search characters
  Future<void> searchCharacters(String query) async {
    if (query.isEmpty) {
      loadCharacters();
      return;
    }

    try {
      emit(CharactersLoading());
      final response = await _apiService.searchCharacters(query);
      emit(CharactersLoaded(characters: response.results));
    } catch (e) {
      emit(CharactersError(message: 'No characters found'));
    }
  }
}