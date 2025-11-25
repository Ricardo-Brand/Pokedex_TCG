import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Busca o mapa de quantidades de cartas do usuário.
  /// Retorna um Map<String, int> onde a chave é o código da carta e o valor é a quantidade.
  Future<Map<String, int>> getCardAmounts() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    try {
      final snapshot = await _firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .get();

      final Map<String, int> amounts = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final code = data['code_card'] as String?;
        final amount = data['amount'] as int?;
        if (code != null && amount != null) {
          amounts[code] = amount;
        }
      }
      return amounts;
    } catch (e) {
      print("Erro ao buscar quantidades: $e");
      return {};
    }
  }

  /// Atualiza a quantidade de uma carta para o usuário.
  /// Se a carta não existir, ela é criada.
  Future<void> updateCardAmount({
    required String pokemonCode,
    required String pokemonName,
    required int newAmount,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return; // Não está logado

    try {
      // 1. Busca a carta na coleção principal para obter seu ID de documento.
      final query = await _firestore
          .collection("pokemons_card")
          .where("code", isEqualTo: pokemonCode.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        print("Carta com código $pokemonCode não encontrada no Pokedex.");
        return;
      }
      final pokemonId = query.docs.first.id;

      // 2. Monta um ID seguro para o documento na subcoleção do usuário.
      final rawId = "${pokemonName.trim()} (${pokemonCode.trim()})";
      final safeId = rawId.replaceAll('/', '-');

      // 3. Referência ao documento do usuário.
      final docRef = _firestore
          .collection("cards_users")
          .doc(user.uid)
          .collection("cards")
          .doc(safeId);

      // 4. Verifica se o documento já existe para decidir se deve criar ou apenas atualizar.
      final doc = await docRef.get();

      if (doc.exists) {
        // Se o documento já existe, atualiza APENAS a quantidade.
        await docRef.update({"amount": newAmount});
      } else {
        // Se o documento não existe, cria com todos os valores padrão.
        await docRef.set({
          "card_id": pokemonId,
          "code_card": pokemonCode,
          "name_card": pokemonName,
          "amount": newAmount,
          "situation": "", "favorite": false, "comment": "", // Valores padrão
        });
      }
    } catch (e) {
      print("Erro ao atualizar quantidade da carta: $e");
    }
  }
}