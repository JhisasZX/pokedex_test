import 'package:flutter/material.dart';

class PokemonDetailPage extends StatelessWidget {
  final String name;
  final String url;
  final int index;

  const PokemonDetailPage({
    super.key,
    required this.name,
    required this.url,
    required this.index,
  });

  String imageUrl(int index) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$index.png';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#$index - ${_capitalize(name)}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl(index), height: 150),
            const SizedBox(height: 20),
            Text(
              _capitalize(name),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('ID: $index'),
            const SizedBox(height: 10),
            Text('URL: $url'),
          ],
        ),
      ),
    );
  }
}
