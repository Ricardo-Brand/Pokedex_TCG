import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_tcg/screens/inicio.dart';
import 'package:pokedex_tcg/screens/login.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Escuta as mudanças no estado de autenticação do Firebase
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto aguarda a conexão, mostra um indicador de progresso
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Se o snapshot tem dados, significa que o usuário está logado
        if (snapshot.hasData) {
          return const InicioScreen();
        }

        // Se não há dados, o usuário não está logado
        return const LoginScreen();
      },
    );
  }
}