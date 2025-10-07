import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/models/pokemon_card.dart'; // importa o model
import 'inicio.dart';
import 'adicionar.dart';
import 'favoritos.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<PokemonCard> _pokemons = [];
  List<int> _quantidades = [];
  String _botaoTexto = "Nome";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    final pokemons = await loadPokemonCards(); // função que lê o .txt
    setState(() {
      _pokemons = pokemons;
      _quantidades = List<int>.filled(_pokemons.length, 0);
    });
  }

  void _ordenarLista() {
    final indices = List.generate(_pokemons.length, (i) => i);

    if (_botaoTexto == "Quantidade") {
      indices.sort((a, b) {
        if (_quantidades[b] != _quantidades[a]) {
          return _quantidades[b].compareTo(_quantidades[a]); // maior quantidade primeiro
        }
        return _pokemons[a].name.toLowerCase().compareTo(_pokemons[b].name.toLowerCase());
      });
    } else {
      indices.sort((a, b) => _pokemons[a].name.toLowerCase().compareTo(_pokemons[b].name.toLowerCase()));
    }

    // Reorganiza _pokemons e _quantidades em-place usando a lista de índices
    final newPokemons = List<PokemonCard>.filled(_pokemons.length, _pokemons[0]);
    final newQuantidades = List<int>.filled(_quantidades.length, 0);

    for (int i = 0; i < indices.length; i++) {
      newPokemons[i] = _pokemons[indices[i]];
      newQuantidades[i] = _quantidades[indices[i]];
    }

    _pokemons = newPokemons;
    _quantidades = newQuantidades;

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
              child: const PokedexTitle(), // aqui entra o const
            ),
          ),

          /* 
            Pesquisar TextField 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 200), // ajuste a posição
              child: SizedBox(
                width: 360, // largura do campo
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: Icon(
                      Icons.search
                    ),
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
                            itemCount: _pokemons.length,
                            itemBuilder: (context, index) {
                              final pokemon = _pokemons[index];
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
                                                    if (_quantidades[index] > 0) {
                                                      _quantidades[index]--;
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
                                              _quantidades[index].toString().padLeft(3, '0'),
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
                                                    _quantidades[index]++;
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
                    // Alterna texto
                    _botaoTexto = _botaoTexto == "Quantidade" ? "Nome" : "Quantidade";

                    // Ordena a lista conforme o modo atual
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
              padding: const EdgeInsets.only(top: 700), // ajuste a posição
              child: Container(
                width: 350,  // largura do quadrado
                height: 55, // altura do quadrado
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
              padding: EdgeInsets.only(top: 747, right: 270), // ajuste a posição vertical
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Pressionar
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0), // cor interna do botão
                    side: const BorderSide(color: Color.fromRGBO(255, 255, 255, 1), width: 2), // borda preta
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // muda o radius das bordas
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
              padding: EdgeInsets.only(top: 747, right: 90), // ajuste a posição vertical
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
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), // cor interna do botão
                    side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2), // borda preta
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // muda o radius das bordas
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
              padding: EdgeInsets.only(top: 747, left: 95), // ajuste a posição vertical
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
                    backgroundColor: Colors.white, // cor interna do botão
                    side: const BorderSide(color: Colors.black, width: 2), // borda preta
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // muda o radius das bordas
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
              padding: EdgeInsets.only(top: 747, left: 275), // ajuste a posição vertical
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
                    backgroundColor: Colors.white, // cor interna do botão
                    side: const BorderSide(color: Colors.black, width: 2), // borda preta
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // muda o radius das bordas
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