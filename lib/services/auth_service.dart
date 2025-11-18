import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerUser({
    required String name,
    required String telefone,
    required String email,
    required String password,
  }) async {
    try {
      // 1 Criar usuário no Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = result.user;
      if (user == null) {
        return "Erro ao criar usuário.";
      }

      // 2 Salvar dados no Firestore (sem a senha!)
      await _firestore.collection("usuarios").doc(user.uid).set({
        "email": email.trim(),
        "nome": name.trim(),
        "telefone": telefone.trim(),
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // 3) Retornar sucesso
      return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // 1) Tentar login com Firebase Auth e obter o UserCredential
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Se o login for bem-sucedido, salvar o UID localmente
      final user = userCredential.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_uid', user.uid);
      }

      // 2) Sucesso → retorna null
      return null;

    } on FirebaseAuthException catch (e) {
      // Erros comuns traduzidos
      if (e.code == 'user-not-found' ||
      e.code == 'wrong-password' || 
      e.code == 'invalid-email' ||
      e.code == 'user-disabled') {
        return 'Usuário inválido';
      }

      // Mensagem padrão
      return e.message;
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }
}
