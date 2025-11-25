import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:pokedex_tcg/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/controllers/rec_senha.controller.dart';

class RecSenhaScreen extends StatefulWidget {
  const RecSenhaScreen({super.key});

  @override
  State<RecSenhaScreen> createState() => _RecSenhaScreenState();
}

class _RecSenhaScreenState extends State<RecSenhaScreen> {
  String buttonText = 'Enviar';
  String infoMessage = '';
  bool firstPress = true;

  final TextEditingController _emailController = TextEditingController();
  final RecSenhaController _controller = RecSenhaController();

  void _mostrarSnackBar(String mensagem, {Color? cor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        backgroundColor: cor ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
            child: const PokedexTitle(),
          ),

          // -------------------------------
          // Título
          // -------------------------------
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.33,
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
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

          // ------------------------------------
          // Campo EMAIL
          // ------------------------------------
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 380, left: 36, right: 32),
              child: SizedBox(
                width: 360,
                child: TextField(
                  controller: _emailController,
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

          // ------------------------------------
          // Botão ENVIAR / REENVIAR
          // ------------------------------------
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
                  onPressed: () async {
                    final email = _emailController.text.trim();

                    if (email.isEmpty) {
                      _mostrarSnackBar('O campo de email não pode estar em branco.',
                          cor: Colors.red);
                      return;
                    }

                    // Chama o controller Firebase
                    final error = await _controller.recuperarSenha(email);

                    if (error != null) {
                      _mostrarSnackBar(error, cor: Colors.red);
                      return;
                    }

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
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------
          // Mensagem de retorno
          // ------------------------------------
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
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
                        ..color = Colors.black,
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

          // ------------------------------------
          // Botão VOLTAR
          // ------------------------------------
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.7,
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
