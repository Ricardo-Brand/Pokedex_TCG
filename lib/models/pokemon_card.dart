import 'package:flutter/services.dart' show rootBundle;

class PokemonCard {
  final String name;
  final String code;

  PokemonCard({required this.name, required this.code});

  @override
  String toString() => "$name ($code)";
}

Future<List<PokemonCard>> loadPokemonCards() async {
  // Carrega o arquivo
  final raw = await rootBundle.loadString('assets/pokemons.txt');

  // Quebra em linhas e remove vazias
  final lines = raw
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  final List<PokemonCard> pokemons = [];

  for (var line in lines) {
    final regex = RegExp(r'^(.*?)\s*\((.*?)\)$');
    final match = regex.firstMatch(line);

    if (match != null) {
      final name = match.group(1)!.trim();
      final code = match.group(2)!.trim();
      pokemons.add(PokemonCard(name: name, code: code));
    } else {
      print("Linha com formato inválido ignorada: $line");
    }
  }

  // Ordena em ordem alfabética pelo nome
  pokemons.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  return pokemons;
}