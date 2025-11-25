import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritosController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Busca o mapa de status de favoritos do usuário.
  /// Retorna um mapa onde a chave é o código da carta e o valor é outro mapa com os dados do usuário.
  Future<Map<String, Map<String, dynamic>>> getCardsData() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    try {
      final snapshot = await _firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .get();

      final Map<String, Map<String, dynamic>> cardsData = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final code = data['code_card'] as String?;
        if (code != null) {
          cardsData[code] = {
            'favorite': data['favorite'] as bool? ?? false,
            'comment': data['comment'] as String? ?? '',
          };
        }
      }
      return cardsData;
    } catch (e) {
      print("Erro ao buscar favoritos: $e");
      return {};
    }
  }

  /// Alterna o status de favorito de uma carta para o usuário.
  /// Se a carta não existir, ela é criada com os valores padrão e marcada como favorita.
  Future<void> toggleFavoriteStatus({
    required String pokemonCode,
    required String pokemonName,
    required bool isCurrentlyFavorite,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 1. Busca a carta na coleção principal para obter seu ID.
      final query = await _firestore
          .collection("pokemons_card")
          .where("code", isEqualTo: pokemonCode.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        print("Carta com código $pokemonCode não encontrada.");
        return;
      }
      final pokemonId = query.docs.first.id;

      // 2. Monta o ID seguro para o documento do usuário.
      final rawId = "${pokemonName.trim()} (${pokemonCode.trim()})";
      final safeId = rawId.replaceAll('/', '-');

      // 3. Referência ao documento do usuário.
      final docRef = _firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .doc(safeId);

      // 4. Verifica se o documento já existe.
      final doc = await docRef.get();

      if (doc.exists) {
        // Se existe, atualiza apenas o status de favorito.
        await docRef.update({"favorite": !isCurrentlyFavorite});
      } else {
        // Se não existe, cria com valores padrão, marcando como favorito.
        await docRef.set({
          "card_id": pokemonId,
          "code_card": pokemonCode,
          "name_card": pokemonName,
          "favorite": true, // Define como favorito na criação
          "amount": 0, "situation": "", "comment": "", // Valores padrão
        });
      }
    } catch (e) {
      print("Erro ao alternar favorito: $e");
    }
  }

  /// Atualiza o comentário de uma carta para o usuário.
  /// Se a carta não existir, ela é criada com os valores padrão.
  Future<void> updateComment({
    required String pokemonCode,
    required String pokemonName,
    required String comment,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 1. Busca a carta na coleção principal para obter seu ID.
      final query = await _firestore
          .collection("pokemons_card")
          .where("code", isEqualTo: pokemonCode.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) return;
      final pokemonId = query.docs.first.id;

      // 2. Monta o ID seguro para o documento do usuário.
      final rawId = "${pokemonName.trim()} (${pokemonCode.trim()})";
      final safeId = rawId.replaceAll('/', '-');

      // 3. Referência ao documento do usuário.
      final docRef = _firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .doc(safeId);

      // 4. Verifica se o documento já existe.
      final doc = await docRef.get();

      if (doc.exists) {
        // Se existe, atualiza apenas o comentário.
        await docRef.update({"comment": comment});
      } else {
        // Se não existe, cria com valores padrão e o comentário atual.
        await docRef.set({
          "card_id": pokemonId,
          "code_card": pokemonCode,
          "name_card": pokemonName,
          "comment": comment,
          "favorite": false, "amount": 0, "situation": "", // Valores padrão
        });
      }
    } catch (e) {
      print("Erro ao atualizar comentário: $e");
    }
  }
}