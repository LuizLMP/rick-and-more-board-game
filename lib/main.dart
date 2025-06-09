import 'package:board_game_rick_morty/core/di/injection_container.dart' as di;
import 'package:board_game_rick_morty/presentation/viewmodels/character_list_viewmodel.dart';
import 'package:board_game_rick_morty/presentation/views/character_list_view.dart';
import 'package:board_game_rick_morty/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<CharacterListViewModel>()),
      ],
      child: MaterialApp(
        title: 'Rick and Morty',
        theme: AppTheme.lightTheme,
        home: const CharacterListView(),
      ),
    );
  }
}
