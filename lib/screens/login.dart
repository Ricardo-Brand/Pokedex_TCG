import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sobre.dart';
import 'recuperar_senha.dart';
import 'cadastrar.dart';
import 'inicio.dart';
import 'package:pokedex_tcg/controllers/login.controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = LoginController();
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  void _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _passwordController.text.trim();

    // 1. validação simples
    if (email.isEmpty || senha.isEmpty) {
      _mostrarSnackBar('Preencha todos os campos.', cor: Colors.red);
      return;
    }

    // 2. chamar o controller
    final resultado = await _loginController.login(email, senha);

    // 3. resultado != null → erro
    if (resultado != null) {
      _mostrarSnackBar('Falha ao entrar. Verifique os dados.', cor: Colors.red);
      return;
    }

    // 4. sucesso → mensagem + navegação
    _mostrarSnackBar('Login realizado com sucesso!', cor: Colors.green);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return; // ← evita erro

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const InicioScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
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
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/fundo.jpeg', fit: BoxFit.cover),

          /*
            Título Pokédex TCG
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 240),
              child: Stack(
                children: [
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
                  Text(
                    'Pokédex\nTCG',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      color: const Color(0xFFE1000C),
                      fontSize: 60,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.white.withOpacity(1.0),
                          offset: const Offset(2, 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /*
            Ícone Pikachu
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 75),
              child: Image.asset(
                'assets/pikachu.png',
                width: 225,
                height: 225,
                fit: BoxFit.contain,
              ),
            ),
          ),

          /*
            Email TextField
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 400, left: 36, right: 32),
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

          /*
            Senha TextField
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 480, left: 36, right: 32),
              child: SizedBox(
                width: 360,
                child: TextField(
                  controller: _passwordController,
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

          /*
          Botão Esqueceu a senha
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 555),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const RecSenhaScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
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
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
                child: const Text('Esqueceu a senha?'),
              ),
            ),
          ),

          /*
            Botão Entrar
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 610, right: 175),
              child: SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                  onPressed: _fazerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1000C),
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

          /*
            Botão Cadastrar
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 610, left: 175),
              child: SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const CadastrarScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
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

          /*
            Botão Sobre
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 700, right: 300),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SobreScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
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
                  child: Center(
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
          ),
        ],
      ),
    );
  }
}