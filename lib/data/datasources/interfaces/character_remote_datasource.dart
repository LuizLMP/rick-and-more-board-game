import 'package:board_game_rick_morty/data/models/character_model.dart';

abstract class CharacterRemoteDataSource {

  Future<List<Character>> getCharacters({int page = 1});

  Future<List<Character>> searchCharacters(String name, {int page = 1});
  
}
