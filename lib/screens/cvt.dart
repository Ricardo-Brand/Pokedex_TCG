import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/models/pokemon_card.dart'; // importa o model
import 'inicio.dart';

class CvtScreen extends StatefulWidget {
  final PokemonCard pokemon; // Pokémon passado de fora

  const CvtScreen({super.key, required this.pokemon});

  @override
  State<CvtScreen> createState() => _CvtScreenState();
}

class _CvtScreenState extends State<CvtScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final pokemon = widget.pokemon;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          /*
            Fundo e Título 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(),
              child: const PokedexTitle(),
            ),
          ),

          /*
           Botão voltar
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.17,
                right: screenWidth * 0.7,
              ),
              child: SizedBox(
                width: screenWidth * 0.2,
                height: screenWidth * 0.1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          /* 
            Lista e seus ícones 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 215),
              child: Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [

                    /* 
                      Linha vertical contínua
                    */

                    Positioned(
                      left: 175,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 5,
                        color: Colors.grey,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        children: [
                          SizedBox(width: 40),
                          Text(
                            'Pokemon',
                            style: GoogleFonts.bungee(
                              textStyle: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0), 
                                fontSize: 20
                              ),
                            ),
                          ),
                          SizedBox(width: 65),
                          Text(
                            'Código',
                            style: GoogleFonts.bungee(
                              textStyle: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0), 
                                fontSize: 20
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 40), 
                      child: Row(
                        children: [

                          /*
                            Coluna Nome
                          */ 

                          SizedBox(
                            width: 120,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                pokemon.name,
                                style: GoogleFonts.bungee(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 60),

                          /*
                            Coluna Código
                          */

                          SizedBox(
                            width: 60,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                pokemon.code,
                                style: GoogleFonts.bungee(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

          /*
            Botão Comprado
          */

          Positioned(
            top: 450,
            left: 22,
            child: SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const InicioScreen(),
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
                  backgroundColor: const Color.fromARGB(255, 110, 110, 110),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Comprado",
                  style: GoogleFonts.bungee(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /*
            Botão Vendido
          */

          Positioned(
            top: 550,
            left: 22,
            child: SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const InicioScreen(),
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
                  backgroundColor: const Color.fromARGB(255, 110, 110, 110)
,                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Vendido",
                  style: GoogleFonts.bungee(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /*
            Botão Trocado
          */

          Positioned(
            top: 650,
            left: 22,
            child: SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const InicioScreen(),
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
                  backgroundColor: const Color.fromARGB(255, 110, 110, 110),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Trocado",
                  style: GoogleFonts.bungee(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}