import 'package:board_game_rick_morty/core/network/interfaces/network_info.dart';
import 'package:board_game_rick_morty/core/network/network_info_impl.dart';
import 'package:board_game_rick_morty/data/datasources/interfaces/character_local_datasource.dart';
import 'package:board_game_rick_morty/data/datasources/interfaces/character_remote_datasource.dart';
import 'package:board_game_rick_morty/data/datasources/local/character_local_datasource_impl.dart';
import 'package:board_game_rick_morty/data/datasources/remote/character_remote_datasource_impl.dart';
import 'package:board_game_rick_morty/data/repositories/character_repository_impl.dart';
import 'package:board_game_rick_morty/domain/repositories/character_repository.dart';
import 'package:board_game_rick_morty/domain/usecases/get_characters_usecase.dart';
import 'package:board_game_rick_morty/domain/usecases/search_characters_usecase.dart';
import 'package:board_game_rick_morty/presentation/viewmodels/character_list_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // ViewModels
  sl.registerFactory(
    () => CharacterListViewModel(
      getCharactersUseCase: sl(),
      searchCharactersUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCharactersUseCase(sl()));
  sl.registerLazySingleton(() => SearchCharactersUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // DataSource
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<CharacterLocalDataSource>(
    () => CharacterLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
}
