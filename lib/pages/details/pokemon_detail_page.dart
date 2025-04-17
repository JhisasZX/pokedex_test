import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonDetailPage extends StatefulWidget {
  final String name;
  final String url;
  final int index;

  const PokemonDetailPage({
    super.key,
    required this.name,
    required this.url,
    required this.index,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late Future<Map<String, dynamic>> pokemonDetails;

  Future<Map<String, dynamic>> fetchPokemonDetails() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los detalles del Pokémon');
    }
  }

  @override
  void initState() {
    super.initState();
    pokemonDetails = fetchPokemonDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name.toUpperCase())),
      body: FutureBuilder(
        future: pokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final stats = data['stats'];
            final imageUrl =
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.index}.png';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(imageUrl, height: 150),
                  const SizedBox(height: 16),
                  Text('Stats:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...stats.map<Widget>((stat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(stat['stat']['name'].toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          Text(stat['base_stat'].toString()),
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            );
          } else {
            return const Center(child: Text('No hay datos'));
          }
        },
      ),
    );
  }
}
