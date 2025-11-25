import 'package:pokedex_tcg/services/auth_service.dart';

class LoginController {  
  final AuthService _authService = AuthService();

  /// Valida campos antes de tentar login
  String? validarCampos(String email, String senha) {
    final emailValido = RegExp(
      r'^[a-zA-Z0-9._-]{3,}@[a-zA-Z.-]{3,}\.[a-zA-Z]{3,}$'
    );

    if (email.isEmpty || senha.isEmpty) {
      return 'Preencha todos os campos.';
    }
    if (!emailValido.hasMatch(email)) {
      return 'O formato do email é inválido.';
    }

    return null; // Sem erros
  }

  /// Tenta realizar o login no Firebase
  Future<String?> login(String email, String senha) async {

    if (validarCampos(email, senha) != null) return 'Email ou senha incorretos.';

    final resultado = await _authService.loginUser(
      email: email,
      password: senha,
    );

    // Retorna o resultado do serviço de autenticação
    return resultado; // Será null em caso de sucesso ou uma string de erro
  }
}