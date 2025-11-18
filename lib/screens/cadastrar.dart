import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:pokedex_tcg/controllers/cadastrar_controller.dart';
import 'login.dart';

class CadastrarScreen extends StatefulWidget {
  const CadastrarScreen({super.key});

  @override
  State<CadastrarScreen> createState() => _CadastrarScreenState();
}

class _CadastrarScreenState extends State<CadastrarScreen> {
  final CadastrarController controller = CadastrarController();

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
        backgroundColor: sucesso ? Colors.green[700] : Colors.red[800],
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
    );
  }

  // -----------------------------
  // 🔥 Função do botão "Cadastrar"
  // -----------------------------
  Future<void> _tentarCadastrar() async {
    // 1) Validar campos
    final erroValidacao = controller.validarCampos();
    if (erroValidacao != null) {
      _mostrarSnackBar(erroValidacao);
      return;
    }

    // 2) Tentar cadastrar no Firebase
    final erroFirebase = await controller.cadastrarFirebase();

    if (erroFirebase != null) {
      _mostrarSnackBar(erroFirebase);
      return;
    }

    // 3) Sucesso!
    _mostrarSnackBar("Usuário cadastrado com sucesso!", sucesso: true);

    controller.limparCampos();

    // 4) Voltar para tela de login
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (context, animation, secAnimation, child) {
          const begin = Offset(-1, 0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.ease),
          );
          return SlideTransition(position: animation.drive(tween), child: child);
        },
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
          const Align(alignment: Alignment.topCenter, child: PokedexTitle()),

          // Campo Nome
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 220),
              child: _buildCampo(controller.nomeController, "Nome"),
            ),
          ),

          // Campo Telefone
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 300),
              child: _buildCampo(
                controller.telefoneController,
                "Telefone",
                maxLength: 11,
                keyboard: TextInputType.number,
              ),
            ),
          ),

          // Campo Email
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 380),
              child: _buildCampo(controller.emailController, "Email"),
            ),
          ),

          // Campo Senha
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 460),
              child: _buildCampoSenha(
                controller.senhaController,
                "Senha",
                () => setState(() => controller.toggleSenha1()),
                controller.obscureSenha1,
              ),
            ),
          ),

          // Campo Confirmar Senha
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 540),
              child: _buildCampoSenha(
                controller.confirmarSenhaController,
                "Confirmar Senha",
                () => setState(() => controller.toggleSenha2()),
                controller.obscureSenha2,
              ),
            ),
          ),

          // Botão Voltar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.8, left: screenWidth * 0.45),
              child: SizedBox(
                width: screenWidth * 0.38,
                height: screenWidth * 0.15,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Voltar',
                    style: GoogleFonts.bungee(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),

          // Botão Cadastrar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.8, right: screenWidth * 0.45),
              child: SizedBox(
                width: screenWidth * 0.38,
                height: screenWidth * 0.15,
                child: ElevatedButton(
                  onPressed: _tentarCadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1000C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Cadastrar',
                    style: GoogleFonts.bungee(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // Widgets auxiliares
  // ------------------------
  Widget _buildCampo(TextEditingController c, String hint,
      {int? maxLength, TextInputType? keyboard}) {
    return SizedBox(
      width: 360,
      child: TextField(
        controller: c,
        maxLength: maxLength,
        keyboardType: keyboard,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildCampoSenha(
    TextEditingController c,
    String hint,
    VoidCallback toggle,
    bool obscure,
  ) {
    return SizedBox(
      width: 360,
      child: TextField(
        controller: c,
        obscureText: obscure,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }
}
