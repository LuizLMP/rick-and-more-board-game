import 'package:board_game_rick_morty/data/models/character_model.dart';

abstract class CharacterLocalDataSource {

  Future<List<Character>> getLastCharacters();

  Future<void> cacheCharacters(List<Character> characters);

}
