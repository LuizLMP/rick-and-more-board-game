import 'package:board_game_rick_morty/core/errors/failures/failure.dart';
import 'package:board_game_rick_morty/domain/entities/character_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CharacterRepository {

  Future<Either<Failure, List<CharacterEntity>>> getCharacters({int page = 1});

  Future<Either<Failure, List<CharacterEntity>>> searchCharacters(
    String name, {
    int page = 1,
  });
}
