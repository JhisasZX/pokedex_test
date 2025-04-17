import 'package:flutter/material.dart';
import 'package:pokedex_test/services/pokedex_service.dart';
import 'package:pokedex_test/pages/details/pokemon_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGrid = false;
  List<dynamic> pokemons = [];
  List<dynamic> filteredPokemons = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPokemons();
  }

  Future<void> loadPokemons() async {
    final data = await PokedexService().getPokemonsList();
    setState(() {
      pokemons = data['results'];
      filteredPokemons = pokemons;
    });
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String imageUrl(int index) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${index + 1}.png';
  }

  void _filterPokemons(String query) {
    setState(() {
      filteredPokemons = pokemons
          .where((pokemon) =>
              pokemon['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          )
        ],
      ),
      body: pokemons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar Pokémon',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: _filterPokemons,
                  ),
                ),
                Expanded(
                  child: isGrid
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                          ),
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredPokemons.length,
                          itemBuilder: (BuildContext context, int index) {
                            final pokemon = filteredPokemons[index];
                            final originalIndex =
                                pokemons.indexOf(pokemon); // para imagen

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonDetailPage(
                                      name: pokemon['name'],
                                      url: pokemon['url'],
                                      index: originalIndex + 1,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        imageUrl(originalIndex),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${originalIndex + 1}. ${_capitalize(pokemon['name'])}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: filteredPokemons.length,
                          itemBuilder: (BuildContext context, int index) {
                            final pokemon = filteredPokemons[index];
                            final originalIndex = pokemons
                                .indexOf(pokemon); // para imagen y número

                            return ListTile(
                              leading: Image.network(imageUrl(originalIndex)),
                              title: Text(
                                '${originalIndex + 1}. ${_capitalize(pokemon['name'])}',
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonDetailPage(
                                      name: pokemon['name'],
                                      url: pokemon['url'],
                                      index: originalIndex + 1,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
