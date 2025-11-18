import 'package:flutter/material.dart';
import 'package:pokedex_tcg/services/auth_service.dart';

class CadastrarController {
  final AuthService _authService = AuthService();

  // Controllers dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  // Controle de visibilidade de senha
  bool obscureSenha1 = true;
  bool obscureSenha2 = true;

  void toggleSenha1() => obscureSenha1 = !obscureSenha1;
  void toggleSenha2() => obscureSenha2 = !obscureSenha2;

  // -------------------------------
  // 🔍 1. Validação dos campos
  // -------------------------------
  String? validarCampos() {
    final nome = nomeController.text.trim();
    final telefone = telefoneController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();
    final confirmarSenha = confirmarSenhaController.text.trim();

    final emailValido = RegExp(
      r'^[a-zA-Z0-9._%+-]{3,}@[a-zA-Z0-9.-]{3,}\.[a-zA-Z]{2,}$'
    );

    if (nome.isEmpty) {
      return 'O nome não pode estar em branco.';
    }
    if (telefone.isEmpty || telefone.length != 11) {
      return 'O telefone deve conter 11 dígitos.';
    }
    if (!emailValido.hasMatch(email)) {
      return 'Digite um email válido (ex: abc@gmail.com).';
    }
    if (senha.isEmpty) {
      return 'A senha não pode estar em branco.';
    }
    if (senha != confirmarSenha) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  // -------------------------------
  // 🟢 2. Cadastro no Firebase
  // -------------------------------
  Future<String?> cadastrarFirebase() async {
    final erro = await _authService.registerUser(
      name: nomeController.text.trim(),
      telefone: telefoneController.text.trim(),
      email: emailController.text.trim(),
      password: senhaController.text.trim(),
    );

    return erro; // null = sucesso // string = erro
  }

  // -------------------------------
  // 🧹 3. Limpar campos após cadastro
  // -------------------------------
  void limparCampos() {
    nomeController.clear();
    telefoneController.clear();
    emailController.clear();
    senhaController.clear();
    confirmarSenhaController.clear();
  }
}
