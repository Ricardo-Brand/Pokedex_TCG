import 'package:cloud_firestore/cloud_firestore.dart';

class PokemonCardF {
   final String name; 
   final String code; 
   final String rarity; 
   final String type; 
   final String setName; 
   final String? situation; 

   PokemonCardF({ 
    required this.name, 
    required this.code, 
    required this.rarity, 
    required this.type, 
    required this.setName, 
    this.situation, 
    }); 
    // Construtor a partir do Firestore 
    factory PokemonCardF.fromFirestore(Map<String, dynamic> data) { 
      return PokemonCardF( 
        name: data['name'] ?? '', 
        code: data['code'] ?? '', 
        rarity: data['rarity'] ?? '', 
        type: data['type'] ?? '', 
        setName: data['setName'] ?? '', 
      ); 
    } 
    @override
    String toString() => "$name ($code)"; 
} 

// --------------------------------------------- 
// 🔥 Função para carregar cartas do Firestore 
// --------------------------------------------- 
Future<List<PokemonCardF>> loadPokemonCards() async { 
  final firestore = FirebaseFirestore.instance; 
  try { 
    final querySnapshot = await firestore.collection('pokemons_card').get(); 
    final List<PokemonCardF> pokemons = querySnapshot.docs.map((doc) { 
      return PokemonCardF.fromFirestore(doc.data()); 
    }).toList(); // Ordena em ordem alfabética 
    
    pokemons.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); 
    return pokemons; 
  } catch (e) { 
    print("Erro ao carregar pokemons"); 
    return []; 
  } 
}
