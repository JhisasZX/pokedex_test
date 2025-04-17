import 'package:flutter/material.dart';
import 'pages/home/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pokedex App'), // Set the title of the app bar
        ),
        body: const HomePage(), // Set the home page to HomePage widget
      ),
    );
  }
}
