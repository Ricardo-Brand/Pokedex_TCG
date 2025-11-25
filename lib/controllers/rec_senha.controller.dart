import 'package:firebase_auth/firebase_auth.dart';

class RecSenhaController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> recuperarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Nenhuma conta encontrada com esse email.";
      }
      if (e.code == 'invalid-email') {
        return "Email inválido.";
      }
      return "Erro ao enviar email de recuperação.";
    } catch (e) {
      return "Erro inesperado.";
    }
  }
}