import 'dart:async';

import 'package:board_game_rick_morty/domain/entities/character_entity.dart';
import 'package:board_game_rick_morty/domain/usecases/get_characters_usecase.dart';
import 'package:board_game_rick_morty/domain/usecases/search_characters_usecase.dart';
import 'package:flutter/material.dart';

enum CharacterListState { initial, loading, loaded, error, empty }

class CharacterListViewModel extends ChangeNotifier {
  final GetCharactersUseCase getCharactersUseCase;
  final SearchCharactersUseCase searchCharactersUseCase;

  CharacterListState _state = CharacterListState.initial;
  CharacterListState get state => _state;

  List<CharacterEntity> _characters = [];
  List<CharacterEntity> get characters => _characters;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _currentPage = 1;
  bool _hasMorePages = true;
  bool get hasMorePages => _hasMorePages;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Timer? _debounce;

  CharacterListViewModel({
    required this.getCharactersUseCase,
    required this.searchCharactersUseCase,
  });

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _setState(CharacterListState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> fetchCharacters({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
      _characters = [];
    }
    if (!_hasMorePages) return;

    _setState(CharacterListState.loading);

    final result = await getCharactersUseCase.execute(page: _currentPage);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(CharacterListState.error);
      },
      (newCharacters) {
        if (newCharacters.isEmpty) {
          _hasMorePages = false;
          if (_characters.isEmpty) {
            _setState(CharacterListState.empty);
          } else {
            _setState(CharacterListState.loaded);
          }
        } else {
          _characters.addAll(newCharacters);
          _currentPage++;
          _setState(CharacterListState.loaded);
        }
      },
    );
  }

  Future<void> _searchCharacters() async {
    _currentPage = 1;
    _hasMorePages = true;
    _characters = [];
    _setState(CharacterListState.loading);

    final result = await searchCharactersUseCase.execute(_searchQuery);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(CharacterListState.error);
      },
      (searchResults) {
        _characters = searchResults;
        if (_characters.isEmpty) {
          _setState(CharacterListState.empty);
        } else {
          _setState(CharacterListState.loaded);
        }
      },
    );
  }

  void setSearchMode(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _currentPage = 1;
    _hasMorePages = true;
    _characters = [];
    fetchCharacters();
  }

  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        clearSearch();
      } else {
        _searchQuery = query;
        _searchCharacters();
      }
    });
  }

  Future<void> loadMoreSearchResults() async {
    if (!_hasMorePages || _searchQuery.isEmpty) return;

    final result = await searchCharactersUseCase.execute(
      _searchQuery,
      page: _currentPage + 1,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (newCharacters) {
        if (newCharacters.isEmpty) {
          _hasMorePages = false;
        } else {
          _characters.addAll(newCharacters);
          _currentPage++;
          notifyListeners();
        }
      },
    );
  }
}
