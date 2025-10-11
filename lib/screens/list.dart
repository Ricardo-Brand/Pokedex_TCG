import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/models/pokemon_card.dart'; // importa o model
import 'inicio.dart';
import 'adicionar.dart';
import 'favoritos.dart';

class PokemonEntry {
  final PokemonCard pokemon;
  int quantidade;

  PokemonEntry(this.pokemon, this.quantidade);
}

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<PokemonEntry> _entries = [];
  String _botaoTexto = "Nome";
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<PokemonEntry> _filteredEntries = [];



  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    final pokemons = await loadPokemonCards();
    setState(() {
      _entries = pokemons.map((p) => PokemonEntry(p, 0)).toList();
      _filteredEntries = List.from(_entries);
    });
  }

  void _searchPokemon(String query) {
    query = query.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEntries = List.from(_entries);
      } else {
        _filteredEntries = _entries.where((entry) {
          final name = entry.pokemon.name.toLowerCase();
          final code = entry.pokemon.code.toLowerCase();
          return name.contains(query) || code.contains(query);
        }).toList();
      }
    });
  }

  void _ordenarLista() {
    if (_botaoTexto == "Quantidade") {
      _entries.sort((a, b) {
        if (b.quantidade != a.quantidade) {
          return b.quantidade.compareTo(a.quantidade);
        }
        return a.pokemon.name.toLowerCase().compareTo(b.pokemon.name.toLowerCase());
      });
    } else {
      _entries.sort((a, b) => a.pokemon.name.toLowerCase().compareTo(b.pokemon.name.toLowerCase()));
    }

    // Reatualiza o filtro também
    _searchPokemon(_searchController.text);

    _scrollController.jumpTo(0.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          /*
            Fundo e Título 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(),
              child: const PokedexTitle(),
            ),
          ),

          /* 
            Pesquisar TextField 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: SizedBox(
                width: 360,
                child: TextField(
                  controller: _searchController,          
                  onChanged: _searchPokemon,           
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    suffixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  ),
                ),
              ),
            ),
          ),

          /* 
            Lista e seus ícones 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 280),
              child: Container(
                width: 350,
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [

                    /* 
                      Linhas verticais contínuas 
                    */

                    Positioned(
                      left: 125,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 5,
                        color: Colors.grey,
                      ),
                    ),

                    /* 
                      Coluna para reservar espaço fixo 
                    */

                    Column(
                      children: [
                        const SizedBox(height: 45),

                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            itemCount: _filteredEntries.length,
                            itemBuilder: (context, index) {
                              final entry = _filteredEntries[index];
                              final pokemon = entry.pokemon;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),

                                    /*
                                    Coluna 1 - Nome
                                    */ 

                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        pokemon.name,
                                        style: GoogleFonts.bungee(
                                          textStyle: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 55),
                                    
                                    /*
                                    Coluna 2 - Código
                                    */
                                    
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        pokemon.code,
                                        style: GoogleFonts.bungee(
                                          textStyle: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /*
                                    Coluna 3 - Adicionar / Subtrair
                                    */

                                    Container(
                                      width: 90,
                                      height: 20,
                                      color: const Color(0xFFD9D9D9),
                                      child: Stack(
                                        children: [

                                          /*
                                            Botão Subtrair
                                          */

                                          Padding(
                                            padding: const EdgeInsets.only(top: 4, left: 5),
                                            child: SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (entry.quantidade > 0) {
                                                      entry.quantidade--;
                                                    }
                                                  });
                                                },
                                                icon: const Icon(Icons.remove,
                                                    color: Colors.white, size: 10),
                                                style: IconButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(0)),
                                                ),
                                              ),
                                            ),
                                          ),

                                          /*
                                            Quantidade
                                          */

                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              entry.quantidade.toString().padLeft(3, '0'),
                                              style: GoogleFonts.bungee(
                                                textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),

                                          /*
                                            Botão Adicionar
                                          */

                                          Padding(
                                            padding: const EdgeInsets.only(top: 4, left: 73),
                                            child: SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    entry.quantidade++;
                                                  });
                                                },
                                                icon: const Icon(Icons.add,
                                                    color: Colors.white, size: 10),
                                                style: IconButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /*
            Texto Pokemon
          */ 

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: 285,
                right: 225,
              ),
              child: Stack(
                children: [
                  Text(
                    'Pokemon',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      fontSize: screenWidth * 0.04,
                      height: 1.4,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = const Color(0xFFE1000C),
                    ),
                  ),
                  Text(
                    'Pokemon',     
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      color: Colors.white, 
                      fontSize: screenWidth * 0.04,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
 
          /*
            Texto Código
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: 285,
                left: 20,
              ),
              child: Stack(
                children: [
                  Text(
                    'Código',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      fontSize: screenWidth * 0.04,
                      height: 1.4,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = const Color(0xFFE1000C),
                    ),
                  ),
                  Text(
                    'Código',     
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bungee(
                      color: Colors.white, 
                      fontSize: screenWidth * 0.04,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /*
            Botão alterar 'Nome' || 'Quantidade'
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 285, left: 230),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _botaoTexto = _botaoTexto == "Quantidade" ? "Nome" : "Quantidade";
                    _ordenarLista();
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _botaoTexto,
                    style: GoogleFonts.alef(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /* 
            Barra de botões
          */

          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 700), 
              child: Container(
                width: 350,  
                height: 55, 
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
            ),
          ),

          /* 
            Botão lista 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 747, right: 270), 
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Pressionar
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0), 
                    side: const BorderSide(color: Color.fromRGBO(255, 255, 255, 1), width: 2), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.list,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          /* 
            Botão home
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 747, right: 90),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const InicioScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),  
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
                    side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.home_filled,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          /* 
            Botão favoritos
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 747, left: 95),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const FavoritosScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),  
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    side: const BorderSide(color: Colors.black, width: 2), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.star_border,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          /* 
            Botão adicionar
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 747, left: 275),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                   onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const AdicionarScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),  
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    side: const BorderSide(color: Colors.black, width: 2), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

        ]
      )
    );
  }
}