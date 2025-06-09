import 'dart:convert';

import 'package:board_game_rick_morty/core/errors/exceptions/cache_exception.dart';
import 'package:board_game_rick_morty/data/datasources/interfaces/character_local_datasource.dart';
import 'package:board_game_rick_morty/data/models/character_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_CHARACTERS_KEY = 'CACHED_CHARACTERS';

  CharacterLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Character>> getLastCharacters() async {
    final jsonString = sharedPreferences.getStringList('CACHED_CHARACTERS');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString as String);
      return jsonList.map((jsonMap) => Character.fromJson(jsonMap)).toList();
    } else {
      throw CacheException(message: 'Nenhum dado em cache');
    }
  }

  @override
  Future<void> cacheCharacters(List<Character> characters) async {
    final List<Map<String, dynamic>> jsonList =
        characters.map((character) => character.toJson()).toList();
    await sharedPreferences.setString(
      CACHED_CHARACTERS_KEY,
      json.encode(jsonList),
    );
  }
}
