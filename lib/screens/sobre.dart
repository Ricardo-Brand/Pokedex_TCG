import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:pokedex_tcg/screens/login.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pegando dimensões da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(),
              child: const PokedexTitle(), // aqui entra o const
            ),
          ),

          // Botão circular voltar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.85,
                right: screenWidth * 0.75,
              ),
              child: SizedBox(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(-1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1000C),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          // Texto descritivo
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.25,
              ),
              child: Stack(
                children: [
                  Text(
                    'O aplicativo permite que colecionadores\n gerenciem suas cartas de forma prática e organizada. É possível marcar cartas compradas, vendidas ou trocadas, assim como registrar as cartas que possui atualmente e suas respectivas quantidades. O app também oferece uma lista de desejos, permite ordenar as cartas por nome ou quantidade e adicionar observações ou anotações em cada carta, facilitando o controle e acompanhamento da coleção.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      fontSize: screenWidth * 0.04,
                      height: 1.4,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.white,
                        
                    ),
                  ),
                  Text(
                    'O aplicativo permite que colecionadores\n gerenciem suas cartas de forma prática e organizada. É possível marcar cartas compradas, vendidas ou trocadas, assim como registrar as cartas que possui atualmente e suas respectivas quantidades. O app também oferece uma lista de desejos, permite ordenar as cartas por nome ou quantidade e adicionar observações ou anotações em cada carta, facilitando o controle e acompanhamento da coleção.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      color: const Color(0xFFE1000C),
                      fontSize: screenWidth * 0.04,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Autores
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.75,
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
              ),
              child: Stack(
                children: [
                  Text(
                    'Autores:\nRicardo Brandão\nLeonardo Lazari',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      fontSize: screenWidth * 0.04,
                      height: 2.0,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.white,
                    ),
                  ),
                  Text(
                    'Autores:\nRicardo Brandão\nLeonardo Lazari',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      color: const Color(0xFFE1000C),
                      fontSize: screenWidth * 0.04,
                      height: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
