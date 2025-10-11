import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:pokedex_tcg/models/usuario.dart';

class CadastrarScreen extends StatefulWidget {
  const CadastrarScreen({super.key});

  @override
  State<CadastrarScreen> createState() => _CadastrarScreenState();
}

class _CadastrarScreenState extends State<CadastrarScreen> {
  bool _obscureSenha_1 = true;
  bool _obscureSenha_2 = true;

  // Controladores dos campos
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  // Função para exibir Snackbar centralizada
  void _mostrarSnackBar(String mensagem, {bool sucesso = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: sucesso ? Colors.green[700] : Colors.red[800],
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
    );
  }

  void _validarCampos() {
    final nome = _nomeController.text.trim();
    final telefone = _telefoneController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final confirmarSenha = _confirmarSenhaController.text.trim();

    final emailValido =
        RegExp(r'^[a-zA-Z0-9._%+-]{3,}@[a-zA-Z0-9.-]{3,}\.[a-zA-Z]{3,}$');

    if (nome.isEmpty) {
      _mostrarSnackBar('O nome não pode estar em branco.');
      return;
    }

    if (telefone.isEmpty || telefone.length > 11) {
      _mostrarSnackBar('O telefone deve conter no máximo 11 dígitos.');
      return;
    }

    if (!emailValido.hasMatch(email)) {
      _mostrarSnackBar('Digite um email válido (ex: abc@gmail.com).');
      return;
    }

    if (senha.isEmpty) {
      _mostrarSnackBar('A senha não pode estar em branco.');
      return;
    }

    if (senha != confirmarSenha) {
      _mostrarSnackBar('As senhas não coincidem.');
      return;
    }

    // Criação do usuário (único)
    try {
      Usuario.criar(
        nome: nome,
        telefone: telefone,
        email: email,
        senha: senha,
      );

      _mostrarSnackBar('Usuário cadastrado com sucesso!', sucesso: true);

      // Após cadastrar, navega para a tela de login após 0 segundos

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
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      );
    } catch (e) {
      _mostrarSnackBar('Erro ao cadastrar usuário.');
    }
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

          /*
            Campo Nome
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 220, left: 36, right: 32),
              child: SizedBox(
                width: 360,
                child: TextField(
                  controller: _nomeController,
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

          /*
            Campo Telefone
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 300, left: 36, right: 32),
              child: SizedBox(
                width: 360,
                child: TextField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: "",
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

          /*
            Campo Email
          */

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

          /*
            Campo Senha
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 460, left: 36, right: 32),
              child: SizedBox(
                width: 360,
                child: TextField(
                  controller: _senhaController,
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

          /*
            Campo Confirmar Senha
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 540, left: 36, right: 32),
              child: SizedBox(
                width: 360,
                child: TextField(
                  controller: _confirmarSenhaController,
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
                        _obscureSenha_2
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
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

          /*
            Botão Voltar
          */ 

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
                          return SlideTransition(position: animation.drive(tween), child: child);
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

          /*
            Botão Cadastrar
          */

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
                  onPressed: _validarCampos,
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
