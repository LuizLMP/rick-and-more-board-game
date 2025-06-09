import 'package:dartz/dartz.dart';
import 'package:board_game_rick_morty/core/errors/failures/failure.dart';
import 'package:board_game_rick_morty/domain/entities/character_entity.dart';
import 'package:board_game_rick_morty/domain/repositories/character_repository.dart';

class GetCharactersUseCase {
  final CharacterRepository repository;

  GetCharactersUseCase(this.repository);

  Future<Either<Failure, List<CharacterEntity>>> execute({int page = 1}) {
    return repository.getCharacters(page: page);
  }
  
}
