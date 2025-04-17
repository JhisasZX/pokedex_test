import 'package:flutter/material.dart';
import 'package:pokedex_test/services/pokedex_service.dart';

/// This widget is the home page of the application.
/// It is a stateless widget that displays a centered text "Home Page".
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PokedexService().getPokemonsList(),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<dynamic> pokemons = snapshot.data['results'];
        return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(pokemons[index]['name']),
              );
            });
      },
    );
  }
}
