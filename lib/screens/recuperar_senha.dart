import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:pokedex_tcg/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';

class RecSenhaScreen extends StatefulWidget {
  const RecSenhaScreen({super.key});

  @override
  State<RecSenhaScreen> createState() => _RecSenhaScreenState();
}

class _RecSenhaScreenState extends State<RecSenhaScreen> {
  String buttonText = 'Enviar';
  String infoMessage = '';
  bool firstPress = true;

  @override
  Widget build(BuildContext context) {
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
              child: const PokedexTitle(),
            ),
          ),

          // Texto descritivo
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.33,
              ),
              child: Stack(
                children: [
                  Text(
                    'Recuperar Senha',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      fontSize: screenWidth * 0.06,
                      height: 1.4,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = const Color(0xFFE1000C),
                    ),
                  ),
                  Text(
                    'Recuperar Senha',     
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      color: Colors.white, 
                      fontSize: screenWidth * 0.06,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),


          // Email TextField
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 380, left: 36, right: 32), // ajuste a posição
              child: SizedBox(
                width: 360, // largura do campo
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botão entrar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.6,
              ),
              child: SizedBox(
                width: screenWidth * 0.35,
                height: screenWidth * 0.15,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (firstPress) {
                        buttonText = 'Reenviar';
                        infoMessage = 'Email enviado com sucesso!';
                        firstPress = false;
                      } else {
                        infoMessage = 'Email reenviado com sucesso!';
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1000C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.bungee(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Padding(
          //     padding: EdgeInsets.only(top: screenHeight * 0.52),
          //     child: Text(
          //       infoMessage,
          //       style: GoogleFonts.bungee(
          //         color: const Color.fromARGB(255, 0, 0, 0),
          //         fontSize: 18,
          //       ),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Padding(
          //     padding: EdgeInsets.only(top: screenHeight * 0.52),
          //     child: Text(
          //       infoMessage,
          //       style: GoogleFonts.bungee(
          //         color: const Color.fromARGB(255, 255, 255, 255),
          //         fontSize: 18,
          //       ),
          //     ),
          //   ),
          // ),

                    // Texto descritivo
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                right: screenWidth * 0,
                top: screenHeight * 0.53,
              ),
              child: Stack(
                children: [
                  Text(
                    infoMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      decoration: TextDecoration.underline,
                      fontSize: screenWidth * 0.044,
                      height: 1.4,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    infoMessage,  
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      decoration: TextDecoration.underline,
                      color: Colors.white, 
                      fontSize: screenWidth * 0.044,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão voltar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.7,
                right: screenWidth * 0.0,
              ),
              child: SizedBox(
                width: screenWidth * 0.35,
                height: screenWidth * 0.15,
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
                    backgroundColor: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Voltar',
                    style: GoogleFonts.bungee(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),



        ],
      ),
    );
  }
}