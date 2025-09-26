import '../models/character_model.dart';

abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;
  final bool hasMore;

  CharactersLoaded({required this.characters, this.hasMore = false});
}

class CharactersError extends CharactersState {
  final String message;

  CharactersError({required this.message});
}