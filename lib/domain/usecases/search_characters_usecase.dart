import 'package:board_game_rick_morty/core/errors/failures/failure.dart';
import 'package:board_game_rick_morty/domain/entities/character_entity.dart';
import 'package:board_game_rick_morty/domain/repositories/character_repository.dart';
import 'package:dartz/dartz.dart';

class SearchCharactersUseCase {
  final CharacterRepository repository;

  SearchCharactersUseCase(this.repository);

  Future<Either<Failure, List<CharacterEntity>>> execute(
    String name, {
    int page = 1,
  }) {
    return repository.searchCharacters(name, page: page);
  }
  
}
