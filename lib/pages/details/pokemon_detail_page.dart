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

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
            final data = snapshot.data!; //information of the pokemon
            final stats = data['stats'];
            final types = data['types'];
            final abilities = data['abilities'];
            final height = data['height'] / 10;
            final weight = data['weight'] / 10;
            final imageUrl =
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.index}.png';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.network(imageUrl, height: 150)),
                  const SizedBox(height: 20),

                  // Altura y Peso
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text("Altura",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('$height m'),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Peso",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('$weight kg'),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tipos
                  const Text("Tipo:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: types
                        .map<Widget>((type) => Chip(
                              label: Text(capitalize(type['type']['name'])),
                              backgroundColor: Colors.lightBlue.shade100,
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // Habilidades
                  const Text("Habilidades:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: abilities
                        .map<Widget>((ability) => Chip(
                              label:
                                  Text(capitalize(ability['ability']['name'])),
                              backgroundColor: Colors.green.shade100,
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // Stats con barra de progreso
                  const Text("Estadísticas:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...stats.map<Widget>((stat) {
                    final String statName = capitalize(stat['stat']['name']);
                    final int value = stat['base_stat'];
                    final double percentage =
                        (value / 255).clamp(0.0, 1.0); // Máximo valor 255

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$statName: $value'),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                percentage > 0.7
                                    ? Colors.green
                                    : percentage > 0.4
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
