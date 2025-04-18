import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos ancho y alto de la pantalla
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA29CBB),
              Color(0xFF7D78A3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/gengar_xz.gif',
                  height: isSmallScreen ? 250 : 500,
                ),
                const SizedBox(height: 20),
                Text(
                  '¡Bienvenido a la Pokédex!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Color.fromARGB(66, 255, 255, 255),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1B2AC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: Text(
                    'Entrar a la Pokédex',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _launchUrl('https://github.com/JhisasZX'),
                      child: Image.asset(
                        'assets/images/github.png',
                        height: isSmallScreen ? 30 : 40,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _launchUrl(
                          'https://www.linkedin.com/in/jesus-machicado-ruiz-545902252/'),
                      child: Image.asset(
                        'assets/images/linkedin.png',
                        height: isSmallScreen ? 30 : 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
