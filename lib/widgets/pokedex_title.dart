import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PokedexTitle extends StatelessWidget {
  const PokedexTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      fit: StackFit.expand,
      children: [
        
        /*
          Fundo cobrindo toda a tela
        */

        Opacity(
          opacity: 0.9, // 50% de transparência
          child: Image.asset(
            'assets/fundo.jpeg',
            fit: BoxFit.cover,
          ),
        ),

        /*
          Título centralizado no topo
        */
         
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.08),
            child: Stack(
              children: [

                /*
                  Stroke (contorno branco)
                */ 

                Text(
                  'Pokédex\nTCG',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bungee(
                    fontSize: screenWidth * 0.14,
                    height: 1.1,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Colors.white,
                  ),
                ),

                /*
                  Texto preenchido (vermelho)
                */
                 
                Text(
                  'Pokédex\nTCG',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bungee(
                    color: const Color(0xFFE1000C),
                    fontSize: screenWidth * 0.14,
                    height: 1.1,
                    shadows: [
                      const Shadow(
                        blurRadius: 8,
                        color: Colors.white,
                        offset: Offset(2, 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
