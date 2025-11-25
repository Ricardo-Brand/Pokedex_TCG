import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CvtController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Define ou atualiza a situação de uma carta do usuário
  Future<void> setSituation({
    required BuildContext context,
    required String code,       // Código da carta no pokedex
    required String situation,  // "Comprado", "Vendido", "Trocado", etc.
  }) async {
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro: Usuário não logado."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // 1️⃣ Busca a carta no pokemons_card
      final query = await firestore
          .collection("pokemons_card")
          .where("code", isEqualTo: code.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Carta não encontrada no pokedex."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final pokemonData = query.docs.first.data();
      final pokemonId = query.docs.first.id;   // ID do documento em pokemons_card
      final name = pokemonData["name"] ?? "Desconhecido";
      final codeCard = pokemonData["code"] ?? code;

      // 2️⃣ Monta ID seguro para o documento do usuário
      final rawId = "${name.trim()} (${code.trim()})";
      final safeId = rawId.replaceAll('/', '-');

      // 3️⃣ Referência ao documento do usuário em cards_users
      final docRef = firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .doc(safeId);

      final doc = await docRef.get();

      if (doc.exists) {
        // Atualiza apenas a situação
        await docRef.update({
          "situation": situation,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Situação atualizada para '$situation'."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Cria documento novo com valores padrão e a situação atual
        await docRef.set({
          "card_id": pokemonId,
          "name_card": name,
          "code_card": codeCard,
          "situation": situation,
          "favorite": false, // Valor padrão
          "amount": 0, // Valor padrão
          "comment": "", // Valor padrão
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Carta adicionada como '$situation'."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao salvar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Remove a situação de uma carta do usuário, setando para ""
  Future<void> removeSituation({
    required BuildContext context,
    required String code,
  }) async {
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro: Usuário não logado."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // 1. Busca a carta na coleção principal para obter o nome.
      final query = await firestore
          .collection("pokemons_card")
          .where("code", isEqualTo: code.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) return; // Sai silenciosamente se a carta não for encontrada

      final pokemonData = query.docs.first.data();
      final name = pokemonData["name"] ?? "Desconhecido";

      // 2. Monta o ID seguro para o documento na subcoleção do usuário.
      final rawId = "${name.trim()} (${code.trim()})";
      final safeId = rawId.replaceAll('/', '-');

      // 3. Referência ao documento do usuário.
      final docRef = firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .doc(safeId);

      // 4. Atualiza o campo 'situation' para uma string vazia.
      await docRef.update({"situation": ""});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Carta removida da lista."), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao remover: $e"), backgroundColor: Colors.red),
      );
    }
  }

  /// Retorna a lista de cards do usuário com situação "Comprado", "Vendido" ou "Trocado"
  Future<List<Map<String, dynamic>>> getUserCardsWithSituation() async {
    final user = auth.currentUser;
    if (user == null) return [];

    try {
      final querySnapshot = await firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .where("situation", whereIn: ["Comprado", "Vendido", "Trocado"])
          .get();

      final cards = querySnapshot.docs.map((doc) {
        final data = doc.data();

        return {
          "card_id": data["card_id"] ?? "",
          "name_card": data["name_card"] ?? "",
          "code_card": data["code_card"] ?? "",
          "situation": data["situation"] ?? "",
          "favorite": data["favorite"] ?? false,
          "amount": data["amount"] ?? 0,
          "comment": data["comment"] ?? "",
        };
      }).toList();

      return cards;
    } catch (e) {
      print("Erro ao buscar cards do usuário: $e");
      return [];
    }
  }

  /// Retorna a lista completa de cartas do pokedex que o usuário possui
  /// com situação válida ("Comprado", "Vendido", "Trocado")
  Future<List<Map<String, dynamic>>> getUserPokemonsFullData() async {
    final userCards = await getUserCardsWithSituation();
    List<Map<String, dynamic>> result = [];

    for (var card in userCards) {
      try {
        final pokemonDoc = await firestore
            .collection("pokemons_card")
            .doc(card["card_id"])
            .get();

        if (pokemonDoc.exists) {
          final pokemonData = pokemonDoc.data()!;
          result.add({
            "name": pokemonData["name"] ?? card["name_card"],
            "code": pokemonData["code"] ?? card["code_card"],
            "situation": card["situation"],
            "favorite": card["favorite"],
            "amount": card["amount"],
            "comment": card["comment"],
          });
        }
      } catch (e) {
        print("Erro ao buscar dados do pokedex para ${card["name_card"]}: $e");
      }
    }

    return result;
  }
}