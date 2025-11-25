import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemons_card.dart';

class InicioController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ---------------------------------------------------
  /// 1. Retorna um Stream que escuta em tempo real as cartas do usuário
  ///    com situação definida ("comprado", "vendido", "trocado") e busca
  ///    os dados completos de cada carta na coleção 'pokemons_card'.
  /// ---------------------------------------------------
  Stream<List<PokemonCardF>> streamPokemonsWithSituation(String userId) {
    try {
      // 1. Escuta as mudanças na subcoleção 'cards' do usuário.
      final userCardsStream = _firestore
          .collection("cards_users")
          .doc(userId)
          .collection("cards")
          .where("situation", whereIn: ["comprado", "vendido", "trocado"])
          .snapshots(); // Usa .snapshots() para obter um Stream

      // 2. Transforma o stream de snapshots do Firestore em um stream de List<PokemonCardF>.
      return userCardsStream.asyncMap((userCardsSnapshot) async {
        final List<PokemonCardF> userPokemons = [];

        // Para cada snapshot, busca os detalhes de cada carta.
        for (var userCardDoc in userCardsSnapshot.docs) {
          final userCardData = userCardDoc.data();
          final cardId = userCardData['card_id'] as String?;
          final situation = userCardData['situation'] as String?;

          if (cardId != null && cardId.isNotEmpty) {
            final pokemonDoc = await _firestore.collection("pokemons_card").doc(cardId).get();

            if (pokemonDoc.exists) {
              final pokemonData = pokemonDoc.data()!;
              userPokemons.add(PokemonCardF(
                name: pokemonData['name'] ?? 'Desconhecido',
                code: pokemonData['code'] ?? '',
                rarity: pokemonData['rarity'] ?? '',
                type: pokemonData['type'] ?? '',
                setName: pokemonData['setName'] ?? '',
                situation: situation,
              ));
            }
          }
        }
        return userPokemons;
      });
    } catch (e) {
      print("Erro ao carregar pokémons do usuário: $e");
      return Stream.value([]); // Retorna um stream vazio em caso de erro.
    }
  }
}
