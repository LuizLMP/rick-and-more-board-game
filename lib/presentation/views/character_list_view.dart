import 'package:board_game_rick_morty/presentation/viewmodels/character_list_viewmodel.dart';
import 'package:board_game_rick_morty/presentation/widgets/character_card.dart';
import 'package:board_game_rick_morty/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterListView extends StatefulWidget {
  const CharacterListView({super.key});

  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterListViewModel>(
        context,
        listen: false,
      ).fetchCharacters();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final vm = Provider.of<CharacterListViewModel>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (vm.state != CharacterListState.loading && vm.hasMorePages) {
        if (vm.isSearching && vm.searchQuery.isNotEmpty) {
          vm.loadMoreSearchResults();
        } else {
          vm.fetchCharacters();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CharacterListViewModel>(
          builder: (context, vm, child) {
            return vm.isSearching
                ? CustomSearchBar(
                  onChanged: vm.onSearchQueryChanged,
                  onClear: vm.clearSearch,
                )
                : const Text(
                  'Rick and Morty',
                  style: TextStyle(fontFamily: 'GetSchwifty',
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
          },
        ),
        actions: [
          Consumer<CharacterListViewModel>(
            builder: (context, vm, child) {
              return IconButton(
                icon: Icon(vm.isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  vm.setSearchMode(!vm.isSearching);
                  if (!vm.isSearching) {
                    vm.clearSearch();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CharacterListViewModel>(
        builder: (context, vm, child) {
          switch (vm.state) {
            case CharacterListState.initial:
            case CharacterListState.loading:
              if (vm.characters.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildCharacterGrid(vm, isLoading: true);

            case CharacterListState.loaded:
              return _buildCharacterGrid(vm);

            case CharacterListState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erro: ${vm.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => vm.fetchCharacters(refresh: true),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );

            case CharacterListState.empty:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      vm.isSearching
                          ? 'Nenhum personagem encontrado para "${vm.searchQuery}"'
                          : 'Nenhum personagem disponível',
                    ),
                    if (vm.isSearching) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: vm.clearSearch,
                        child: const Text('Limpar Pesquisa'),
                      ),
                    ],
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildCharacterGrid(
    CharacterListViewModel vm, {
    bool isLoading = false,
  }) {
    return RefreshIndicator(
      onRefresh: () => vm.fetchCharacters(refresh: true),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: vm.characters.length + (isLoading ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= vm.characters.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final character = vm.characters[index];
          return CharacterCard(
            character: character,
            onTap: () {},
          );
        },
      ),
    );
  }
}
