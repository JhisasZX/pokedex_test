import 'package:flutter/material.dart';
import 'package:pokedex_test/services/pokedex_service.dart';
import 'package:pokedex_test/pages/details/pokemon_detail_page.dart'; // asegurate que exista esta página

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String imageUrl(int index) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${index + 1}.png';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PokedexService().getPokemonsList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final Map<String, dynamic> data = snapshot.data;
          final List<dynamic> pokemons = data['results'];

          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.network(imageUrl(index)),
                title: Text(
                    '${index + 1}. ${_capitalize(pokemons[index]['name'])}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonDetailPage(
                        name: pokemons[index]['name'],
                        url: pokemons[index]['url'],
                        index: index + 1,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: Text('No hay datos'));
        }
      },
    );
  }
}
