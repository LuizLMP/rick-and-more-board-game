import 'package:board_game_rick_morty/core/errors/exceptions/server_exception.dart';
import 'package:board_game_rick_morty/data/datasources/interfaces/character_remote_datasource.dart';
import 'package:board_game_rick_morty/data/models/character_model.dart';
import 'package:dio/dio.dart';

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://rickandmortyapi.com/api';
  
  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Character>> getCharacters({int page = 1}) async {
    try {
      final response = await dio.get('$baseUrl/character/?page=$page');
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((character) => Character.fromJson(character))
            .toList();
      } else {
        throw ServerException(
          message: 'Falha ao carregar personagens',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<Character>> searchCharacters(String name, {int page = 1}) async {
    try {
      final response = await dio.get(
        '$baseUrl/character/',
        queryParameters: {'name': name, 'page': page},
      );
      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((character) => Character.fromJson(character))
            .toList();
      } else {
        throw ServerException(
          message: 'Falha ao buscar personagens',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
