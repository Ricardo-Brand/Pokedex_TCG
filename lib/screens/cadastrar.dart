import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class CadastrarScreen extends StatefulWidget {
  const CadastrarScreen({super.key});

  @override
  State<CadastrarScreen> createState() => _CadastrarScreenState();
}


class _CadastrarScreenState extends State<CadastrarScreen> {
  bool _obscureSenha_1 = true;
  bool _obscureSenha_2 = true;

  @override
  Widget build(BuildContext context){
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

          // Nome TextField
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 220, left: 36, right: 32), // ajuste a posição
              child: SizedBox(
                width: 360, // largura do campo
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Nome',
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

          // Telefone TextField
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 300, left: 36, right: 32), // ajuste a posição
              child: SizedBox(
                width: 360, // largura do campo
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Telefone',
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

          // Senha TextField
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 460, left: 36, right: 32), // ajuste a posição
              child: SizedBox(
                width: 360, // largura do campo
                child: TextField(
                  textAlign: TextAlign.center,
                  obscureText: _obscureSenha_1,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureSenha_1 
                          ? Icons.visibility_off 
                          : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureSenha_1 = !_obscureSenha_1;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

           // Confirmar Senha TextField
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 540, left: 36, right: 32), // ajuste a posição
              child: SizedBox(
                width: 360, // largura do campo
                child: TextField(
                  textAlign: TextAlign.center,
                  obscureText: _obscureSenha_2,
                  decoration: InputDecoration(
                    hintText: 'Confirmar Senha',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureSenha_1
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: Colors.grey
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureSenha_2 = !_obscureSenha_2;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botão voltar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.8,
                left: screenWidth * 0.45,
              ),
              child: SizedBox(
                width: screenWidth * 0.38,
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

          // Botão cadastrar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.8,
                right: screenWidth * 0.45,
              ),
              child: SizedBox(
                width: screenWidth * 0.38,
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
                    backgroundColor: const Color(0xFFE1000C),
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


        ],
      ),
    );
  }
}