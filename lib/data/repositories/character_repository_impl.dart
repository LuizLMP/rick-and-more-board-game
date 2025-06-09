import 'package:board_game_rick_morty/core/errors/exceptions/cache_exception.dart';
import 'package:board_game_rick_morty/core/errors/exceptions/server_exception.dart';
import 'package:board_game_rick_morty/core/errors/failures/cache_failure.dart';
import 'package:board_game_rick_morty/core/errors/failures/failure.dart';
import 'package:board_game_rick_morty/core/errors/failures/network_failure.dart';
import 'package:board_game_rick_morty/core/errors/failures/server_failure.dart';
import 'package:board_game_rick_morty/core/network/interfaces/network_info.dart';
import 'package:board_game_rick_morty/data/datasources/interfaces/character_local_datasource.dart';
import 'package:board_game_rick_morty/data/datasources/interfaces/character_remote_datasource.dart';
import 'package:board_game_rick_morty/domain/entities/character_entity.dart';
import 'package:board_game_rick_morty/domain/repositories/character_repository.dart';
import 'package:dartz/dartz.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CharacterEntity>>> getCharacters({
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCharacters = await remoteDataSource.getCharacters(
          page: page,
        );
        localDataSource.cacheCharacters(remoteCharacters);
        return Right(remoteCharacters);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final localCharacters = await localDataSource.getLastCharacters();
        return Right(localCharacters);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<CharacterEntity>>> searchCharacters(
    String name, {
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCharacters = await remoteDataSource.searchCharacters(
          name,
          page: page,
        );
        return Right(remoteCharacters);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'Sem conexão com a internet'));
    }
  }
}
