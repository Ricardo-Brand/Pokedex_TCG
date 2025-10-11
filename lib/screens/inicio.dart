import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/models/pokemon_card.dart'; // importa o model
import 'login.dart';
import 'list.dart';
import 'adicionar.dart';
import 'cvt.dart';
import 'favoritos.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  bool showDetails = false;
  List<PokemonCard> _pokemons = [];
  final TextEditingController _searchController = TextEditingController();
  List<PokemonCard> _filteredPokemons = [];

  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    final pokemons = await loadPokemonCards(); // função que lê o .txt
    setState(() {
      _pokemons = pokemons;
      _filteredPokemons = pokemons; // exibe tudo inicialmente
    });
  }

  String _getStatus(int index) {
    // Exemplo simples: alterna entre os três
    switch (index % 3) {
      case 0:
        return "Comprado";
      case 1:
        return "Vendido";
      default:
        return "Trocado";
    }
  }

  void _searchPokemon(String query) {
    query = query.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredPokemons = _pokemons;
      } else {
        _filteredPokemons = _pokemons.where((pokemon) {
          final name = pokemon.name.toLowerCase();
          final code = pokemon.code.toLowerCase();
          return name.contains(query) || code.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
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
           Botão logout 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.17,
                right: screenWidth * 0.7,
              ),
              child: SizedBox(
                width: screenWidth * 0.2,
                height: screenWidth * 0.1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(-1.0, 0.0);
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
                    backgroundColor: const Color(0xFFE1000C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
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
                      left: 110,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 5,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      right: 140,
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
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            itemCount: _filteredPokemons.length,
                            itemBuilder: (context, index) {
                               final pokemon =  _filteredPokemons[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    
                                    /* 
                                      Coluna 1 - Nome do Pokémon 
                                    */

                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        pokemon.name,
                                         style: GoogleFonts.bungee(
                                          textStyle: TextStyle(
                                            fontSize: 10,
                                            color: const Color.fromARGB(255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 8),

                                    /* 
                                      Coluna 2 - Código 
                                    */

                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        pokemon.code,
                                         style: GoogleFonts.bungee(
                                          textStyle: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 35),

                                    /* 
                                      Coluna 3 - Situação 
                                    */

                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        _getStatus(index),
                                        style: GoogleFonts.bungee(
                                          textStyle: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 5),

                                    /* 
                                      Coluna 4 - Botão Edit 
                                    */

                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final pokemon = _pokemons[index];
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor: Colors.black.withOpacity(0.75),
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                backgroundColor: Colors.transparent, 
                                                insetPadding: EdgeInsets.all(20), 
                                                child: Container(
                                                  width: 600,
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFD9D9D9),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),

                                                  /* 
                                                    Ícones dentro do quadrado
                                                  */

                                                  child: Stack(
                                                    children: [
                                                      // linha do meio
                                                      Positioned(
                                                        left: 170, 
                                                        top: 0,
                                                        bottom: 150,
                                                        child: Container(
                                                          width: 6,
                                                          height: 0,
                                                          color: Color(0xFFA4A4A4), 
                                                        ),
                                                      ),

                                                      /*
                                                        Botão Voltar
                                                      */

                                                      Positioned(
                                                        top: 200,    
                                                        right: 130,  
                                                        child: SizedBox(
                                                          width: 100,  
                                                          height: 40,  
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(context); 
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0xFF1E1E1E),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20), 
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "Voltar",
                                                              style: GoogleFonts.bungee(
                                                                textStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      /*
                                                        Botão Remover
                                                      */ 

                                                      Positioned(
                                                        top: 150,    
                                                        right: 195,  
                                                        child: SizedBox(
                                                          width: 120,  
                                                          height: 40,  
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(context); 
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0xFFC00F0C),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20), 
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "Remover",
                                                              style: GoogleFonts.bungee(
                                                                textStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      /*
                                                        Botão Editar
                                                      */         
                                                    
                                                      Positioned(
                                                        top: 150,    
                                                        right: 40,  
                                                        child: SizedBox(
                                                          width: 120,  
                                                          height: 40,  
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              final selectedPokemon = _pokemons[index];
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                                                     CvtScreen(pokemon: selectedPokemon),
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
                                                              backgroundColor: const Color(0xFFC00F0C),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20), 
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "Editar",
                                                              style: GoogleFonts.bungee(
                                                                textStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      /* 
                                                        Text 'Pokemon', 'Código'
                                                      */

                                                      Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(width: 40),
                                                            Text(
                                                              'Pokemon',
                                                              style: GoogleFonts.bungee(
                                                                textStyle: TextStyle(
                                                                  color: const Color.fromARGB(255, 0, 0, 0), 
                                                                  fontSize: 20
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 60),
                                                            Text(
                                                              'Código',
                                                              style: GoogleFonts.bungee(
                                                                textStyle: TextStyle(
                                                                  color: const Color.fromARGB(255, 0, 0, 0), 
                                                                  fontSize: 20
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      
                                                      /* 
                                                        Nome e Código pokémon
                                                      */

                                                     Padding(
                                                      padding: const EdgeInsets.only(top: 60, left: 40), 
                                                      child: Row(
                                                        children: [

                                                          /*
                                                            Coluna Nome
                                                          */ 

                                                          SizedBox(
                                                            width: 120,
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown, 
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                pokemon.name,
                                                                style: GoogleFonts.bungee(
                                                                  fontSize: 15, 
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          SizedBox(width: 60),

                                                          /*
                                                            Coluna Código
                                                          */ 

                                                          SizedBox(
                                                            width: 60,
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                pokemon.code,
                                                                style: GoogleFonts.bungee(
                                                                  fontSize: 15,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                      
                                                    ],
                                                  ),
                                                  
                                                ),
                                              );
                                            },
                                          );
                                        },

                                        /* 
                                          Botões Editar - Lista
                                        */

                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 10,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                        ),
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
                right: 240,
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
                right: 30,
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
            Texto Situação 
          */

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: 285,
                left: 200,
              ),
              child: Stack(
                children: [
                  Text(
                    'Situação',
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
                    'Situação',     
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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ListaScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(-1.0, 0.0);
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
                    Icons.list,
                    color: Color.fromARGB(255, 0, 0, 0),
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
                    // Pressionar
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0), 
                    side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 2), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), 
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.home_filled,
                    color: Color.fromARGB(255, 255, 255, 255),
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

        ],
      ),
    );
  }
}