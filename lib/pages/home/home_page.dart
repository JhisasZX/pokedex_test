import 'package:flutter/material.dart';
import 'package:pokedex_test/services/pokedex_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
                title: Text(_capitalize(pokemons[index]['name'])),
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
