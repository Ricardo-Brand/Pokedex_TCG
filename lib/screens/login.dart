import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sobre.dart';
import 'recuperar_senha.dart';
import 'cadastrar.dart';
import 'inicio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(
            'assets/fundo.jpeg',
            fit: BoxFit.cover,
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 240), // ajuste aqui a distância do topo
              child: Stack(
                children: [
                  // Stroke (contorno branco)
                  Text(
                    'Pokédex\nTCG',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      fontSize: 60,
                      height: 1.1,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.white,
                    ),
                  ),
                  // Texto preenchido (vermelho)
                  Text(
                    'Pokédex\nTCG',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      color: Color(0xFFE1000C),
                      fontSize: 60,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.white.withOpacity(1.0),
                          offset: Offset(2, 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Emoji 
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 25, left: 75), // ajuste aqui a distância do topo
              child: Image.asset(
                'assets/pikachu.png',
                width: 225, // ajuste o tamanho conforme necessário
                height: 225,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Email TextField
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 400, left: 36, right: 32), // ajuste a posição
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


          // Senha TextField
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 480, left: 36, right: 32),
              child: SizedBox(
                width: 360,
                child: TextField(
                  textAlign: TextAlign.center,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Esqueceu a senha?
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 555), // ajuste a posição vertical
              child: TextButton(
                onPressed: () {
                  // Navegar para a tela LoginScreen com animação personalizada
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const RecSenhaScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        // Define de onde a tela nova vai começar
                        const begin = Offset(1.0, 0.0); // 1.0 = fora da tela pela DIREITA
                        const end = Offset.zero;        // 0.0 = posição normal
                        const curve = Curves.easeInOut; // curva suave

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
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: Colors.white, // cor do texto
                  textStyle: const TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline, // sublinhado
                  ),
                ),
                child: const Text('Esqueceu a senha?'),
              ),
            ),
          ),

          // Botão Entrar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 610, right: 175), // ajuste a posição vertical
              child: SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                   onPressed: () {
                  // Navegar para a tela LoginScreen com animação personalizada
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const InicioScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        // Define de onde a tela nova vai começar
                        const begin = Offset(1.0, 0.0); // 1.0 = fora da tela pela DIREITA
                        const end = Offset.zero;        // 0.0 = posição normal
                        const curve = Curves.easeInOut; // curva suave

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
                    backgroundColor: Color(0xFFE1000C), // cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Entrar',
                    style: GoogleFonts.bungee(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),


          // Botão Cadastrar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 610, left: 175), // ajuste a posição vertical
              child: SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Navegar para a tela LoginScreen com animação personalizada
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const CadastrarScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // Define de onde a tela nova vai começar
                          const begin = Offset(1.0, 0.0); // 1.0 = fora da tela pela DIREITA
                          const end = Offset.zero;        // 0.0 = posição normal
                          const curve = Curves.easeInOut; // curva suave

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
                    backgroundColor: Color(0xFF1E1E1E), // cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cadastrar',
                    style: GoogleFonts.bungee(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botão circular Sobre
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 700, right: 300), // ajuste a posição vertical
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navegar para a tela LoginScreen com animação personalizada
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const SobreScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // Define de onde a tela nova vai começar
                          const begin = Offset(1.0, 0.0); // 1.0 = fora da tela pela DIREITA
                          const end = Offset.zero;        // 0.0 = posição normal
                          const curve = Curves.easeInOut; // curva suave

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
                    backgroundColor: Color(0xFFE1000C),
                    shape: const CircleBorder(), // formato de bola
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    '?',
                    style: GoogleFonts.bungee(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      )
    );
  }
}