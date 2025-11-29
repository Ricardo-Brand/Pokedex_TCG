import 'package:flutter/material.dart';
import 'package:pokedex_tcg/widgets/pokedex_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_tcg/models/pokemons_card.dart'; // importa o model
import 'package:pokedex_tcg/controllers/favoritos.controller.dart';
import 'list.dart';
import 'inicio.dart';
import 'adicionar.dart';

class PokeballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final centerY = size.height / 2;

    // 🔴 Metade superior (vermelha)
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14,
      3.14,
      true,
      paint,
    );

    // ⚪ Metade inferior (branca)
    paint.color = Colors.white;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      3.14,
      true,
      paint,
    );

    // ⚫ Linha do meio (separa vermelho e branco)
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      paint,
    );

    // ⚫ Borda externa
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    // ⚫ Botão central
    paint.style = PaintingStyle.fill;
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      paint,
    );

    // ⚪ Centro interno do botão
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.07,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final FavoritosController _controller = FavoritosController();
  List<PokemonCardF> _allPokemons = []; // Lista original, nunca modificada
  List<PokemonCardF> _filteredPokemons = [];
  Map<String, Map<String, dynamic>> _cardsData = {};
  bool _isLoading = true; // Novo: para controlar o estado de carregamento

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Só carrega se os dados ainda não foram obtidos
    if (_allPokemons.isEmpty) {
      // 1. Busca todas as cartas e os dados do usuário em paralelo
      final results = await Future.wait([
        loadPokemonCards(),
        _controller.getCardsData(),
      ]);

      final pokemons = results[0] as List<PokemonCardF>;
      final cardsData = results[1] as Map<String, Map<String, dynamic>>;

      setState(() {
        _allPokemons = pokemons;
        _cardsData = cardsData;
        // Aplica o filtro e a ordenação iniciais
        _applyFilterAndSort();
        _isLoading = false; // Finaliza o carregamento
      });
    }
  }

  void _searchPokemon(String query) {
    setState(() {
      _applyFilterAndSort();
    });
  }

  // Nova função que combina filtro e ordenação
  void _applyFilterAndSort() {
    final query = _searchController.text.trim().toLowerCase();
    List<PokemonCardF> tempPokemons;

    if (query.isEmpty) {
      tempPokemons = List.from(_allPokemons);
    } else {
      tempPokemons = _allPokemons.where((pokemon) {
        final name = pokemon.name.toLowerCase();
        final code = pokemon.code.toLowerCase();
        return name.contains(query) || code.contains(query);
      }).toList();
    }

    // Ordena a lista temporária
    tempPokemons.sort((a, b) {
      final aData = _cardsData[a.code] ?? {'favorite': false};
      final bData = _cardsData[b.code] ?? {'favorite': false};
      final isAFavorite = aData['favorite'] as bool;
      final isBFavorite = bData['favorite'] as bool;

      if (isAFavorite && !isBFavorite) {
        return -1; // a (favorito) vem antes de b (não favorito)
      }
      if (!isAFavorite && isBFavorite) {
        return 1; // b (favorito) vem antes de a (não favorito)
      }
      // Se ambos são favoritos ou não, ordena por nome
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    // Atualiza a lista que será exibida
    _filteredPokemons = tempPokemons;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _commentController.dispose();
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
                width: 360, // mantém o tamanho
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

                        if (_isLoading)
                          const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              itemCount: _filteredPokemons.length,
                              itemBuilder: (context, index) {
                                final pokemon = _filteredPokemons[index];
                                final cardData = _cardsData[pokemon.code] ?? {'favorite': false, 'comment': ''};
                                final isFavorite = cardData['favorite'] as bool;
                                final comment = cardData['comment'] as String;
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
                                      Coluna 3 - Botão comentário
                                    */

                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          onPressed: () {
                                            _commentController.text = comment;

                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierColor: Colors.black.withOpacity(0.75),
                                              builder: (dialogContext) { // Início do builder do showDialog
                                                return StatefulBuilder( // Para atualizar o estado do dialog (contador)
                                                  builder: (context, setStateDialog) { // Início do builder do StatefulBuilder
                                                    return Material(
                                                      color: Colors.transparent,
                                                      child: UnconstrainedBox(
                                                        child: Stack(
                                                          clipBehavior: Clip.none,
                                                          children: [
                                                            // ... (conteúdo do dialog)
                                                        
                                                        /*
                                                          Quadrado externo maior que a lista
                                                        */ 

                                                        Container(
                                                          width: 380,
                                                          height: 360,
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFBEBEBE),
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                        ),

                                                        /*
                                                          Quadrado interno
                                                        */ 

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 70, left: 10),
                                                          child: Container(
                                                            width: 360,
                                                            height: 200,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(10),
                                                              border: Border.all(color: Colors.grey.shade400),
                                                            ), 
                                                            child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 20), // Espaço para o contador
                                                                  child: TextField(
                                                                    keyboardType: TextInputType.multiline,
                                                                    maxLines: null,
                                                                    controller: _commentController,
                                                                    maxLength: 200, // Limite de caracteres
                                                                    onChanged: (text) {
                                                                      setStateDialog(() {}); // Atualiza o contador
                                                                    },
                                                                    decoration: const InputDecoration(
                                                                      hintText: "Escreva seu comentário...",
                                                                      border: InputBorder.none,
                                                                      counterText: '', // Oculta o contador padrão
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 5,
                                                                  right: 10,
                                                                  child: Text(
                                                                    '${_commentController.text.length}/200',
                                                                    style: TextStyle(
                                                                      color: Colors.grey[600],
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                              ),
                                                            ),
                                                          ),
                                                        

                                                        /* 
                                                          Comentário
                                                        */
                                                          
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5, left: 110),
                                                          child: Row(
                                                            children: [

                                                              /*
                                                                Coluna Nome
                                                              */

                                                              SizedBox(
                                                                width: 150,
                                                                child: FittedBox(
                                                                  fit: BoxFit.scaleDown,
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                    "Comentário",
                                                                    style: GoogleFonts.bungee(
                                                                      fontSize: 40,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        /* 
                                                          Nome
                                                        */
                                                        
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 30, left: 90),
                                                          child: Row(
                                                            children: [

                                                              /*
                                                                Nome do Pokémon
                                                              */ 

                                                              Stack(
                                                                children: [
                                                                  Text(
                                                                    pokemon.name,
                                                                    style: GoogleFonts.bungee(
                                                                      fontSize: 14,
                                                                      foreground: Paint()
                                                                        ..style = PaintingStyle.stroke
                                                                        ..strokeWidth = 2
                                                                        ..color = Colors.white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    pokemon.name,
                                                                    style: GoogleFonts.bungee(
                                                                      fontSize: 14,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                            ],
                                                          ),
                                                        ),

                                                        /* 
                                                          Código
                                                        */

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 30, left: 230),
                                                          child: Row(
                                                            children: [

                                                              /*
                                                                Nome do Pokémon
                                                              */

                                                              Stack(
                                                                children: [
                                                                  Text(
                                                                    pokemon.code,
                                                                    style: GoogleFonts.bungee(
                                                                      fontSize: 14,
                                                                      foreground: Paint()
                                                                        ..style = PaintingStyle.stroke
                                                                        ..strokeWidth = 2
                                                                        ..color = Colors.white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    pokemon.code,
                                                                    style: GoogleFonts.bungee(
                                                                      fontSize: 14,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        /*
                                                          Pokebola 
                                                        */

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 50, top: 10),
                                                          child: CustomPaint(
                                                            size: Size(20, 20),
                                                            painter: PokeballPainter(),
                                                          ),
                                                        ),

                                                        /*
                                                          Circulo vermelho 
                                                        */

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 13, left: 280),
                                                          child: Container(
                                                            width: 13,
                                                            height: 13,
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromARGB(255, 255, 0, 0),
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.black, 
                                                                width: 2, 
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Circulo amarelo
                                                        */

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 13, left: 310),
                                                          child: Container(
                                                            width: 13,
                                                            height: 13,
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromARGB(255, 255, 230, 0),
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.black,
                                                                width: 2, 
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Circulo verde
                                                        */

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 13, left: 340),
                                                          child: Container(
                                                            width: 13,
                                                            height: 13,
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromARGB(255, 55, 255, 0),
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.black,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Circulo preto e cinza 
                                                        */

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 295, left: 25),
                                                          child: Container(
                                                            width: 45,
                                                            height: 45,
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFF696969),
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.black,
                                                                width: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Barra preta inferior
                                                        */

                                                        Positioned(
                                                          top: 295,
                                                          left: 320,
                                                          child: Container(
                                                            width: 20, 
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                              color: Color.fromARGB(255, 0, 0, 0),
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Barra preta inferior horizontal
                                                        */

                                                        Positioned(
                                                          top: 311,
                                                          left: 305,
                                                          child: Container(
                                                            width: 50, 
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color: Color.fromARGB(255, 0, 0, 0),
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Circulo cinza 
                                                        */

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 310, left: 320),
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFF2E2E2E),
                                                              shape: BoxShape.circle,
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Barra inferior verde
                                                        */

                                                        Positioned(
                                                          top: 295,
                                                          left: 90,
                                                          child: Container(
                                                            width: 200,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFF00A32E),
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Botão voltar
                                                        */ 

                                                        Positioned(
                                                          top: 305,
                                                          right: 215,
                                                          child: SizedBox(
                                                            width: 60,
                                                            height: 30,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                padding: EdgeInsets.zero, 
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  side: const BorderSide(
                                                                    color: Colors.black,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                backgroundColor: Colors.transparent,
                                                                shadowColor: Colors.transparent,
                                                              ).copyWith(
                                                                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                                                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                                                                elevation: WidgetStateProperty.all(0),
                                                              ),
                                                              child: Ink(
                                                                decoration: BoxDecoration(
                                                                  gradient: const LinearGradient(
                                                                    colors: [
                                                                      Color(0xFFFF0000), 
                                                                      Colors.black, 
                                                                      Color(0xFFFF0000),
                                                                    ],
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  border: Border.all(
                                                                    color: Colors.black,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Voltar",
                                                                    style: GoogleFonts.lato(
                                                                      textStyle: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        /*
                                                          Botão salvar
                                                        */ 

                                                        Positioned(
                                                          top: 305,
                                                          right: 105,
                                                          child: SizedBox(
                                                            width: 60,
                                                            height: 30,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                final newComment = _commentController.text;
                                                                _controller.updateComment(
                                                                  pokemonCode: pokemon.code,
                                                                  pokemonName: pokemon.name,
                                                                  comment: newComment,
                                                                );

                                                                setState(() {
                                                                  _cardsData[pokemon.code] = {
                                                                    'favorite': isFavorite,
                                                                    'comment': newComment,
                                                                  };
                                                                });
                                                                Navigator.pop(context); // Fecha o dialog de comentário
                                                                showDialog( // Mostra o dialog de sucesso
                                                                  context: context,
                                                                  barrierDismissible: true,
                                                                  barrierColor: Colors.black.withOpacity(0.75),
                                                                  builder: (context) {
                                                                    return Material(
                                                                      color: Colors.transparent,
                                                                      child: Center(
                                                                        child: SizedBox(
                                                                          width: 360,
                                                                          height: 250,
                                                                          child: Stack(
                                                                            clipBehavior: Clip.none,
                                                                            children: [

                                                                              /*
                                                                                Quadrado externo
                                                                              */

                                                                              Positioned(
                                                                                top: 40,
                                                                                left: 30,
                                                                                child: Container(
                                                                                  width: 300,
                                                                                  height: 150,
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(0xFFBEBEBE),
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              /*
                                                                                Quadrado interno
                                                                              */

                                                                              Positioned(
                                                                                top: 70,
                                                                                left: 55,
                                                                                child: Container(
                                                                                  width: 250,
                                                                                  height: 75,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              /*
                                                                                String dentro do quadrado interno 
                                                                              */

                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 100, left: 65),
                                                                                child: Row(
                                                                                  children: [

                                                                                    /*
                                                                                      Coluna Nome
                                                                                    */ 

                                                                                    SizedBox(
                                                                                      width: 250,
                                                                                      child: FittedBox(
                                                                                        fit: BoxFit.scaleDown,
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Text(
                                                                                          "COMENTÁRIO SALVO COM SUCESSO",
                                                                                          style: GoogleFonts.bungee(
                                                                                            fontSize: 12,
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),

                                                                              /*
                                                                                Botão voltar
                                                                              */

                                                                              Positioned(
                                                                                top: 152,
                                                                                left: 148,
                                                                                child: SizedBox(
                                                                                  width: 60,
                                                                                  height: 30,
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context); // Fecha o dialog de sucesso
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      padding: EdgeInsets.zero,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                        side: const BorderSide(color: Colors.black, width: 2),
                                                                                      ),
                                                                                      backgroundColor: Colors.transparent,
                                                                                      shadowColor: Colors.transparent,
                                                                                    ),
                                                                                    child: Ink(
                                                                                      decoration: BoxDecoration(
                                                                                        gradient: const LinearGradient(
                                                                                          colors: [Color(0xFF00A32E), Color(0xFF007020), Color(0xFF003D11)],
                                                                                          begin: Alignment.topCenter,
                                                                                          end: Alignment.bottomCenter,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                      ),
                                                                                      child: const Center(
                                                                                        child: Text(
                                                                                          "Ok",
                                                                                          style: TextStyle(fontSize: 14, color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),


                                                                              /*
                                                                                Circulo vermelho 
                                                                              */

                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 45, left: 140),
                                                                                child: Container(
                                                                                  width: 13,
                                                                                  height: 13,
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color.fromARGB(255, 255, 0, 0),
                                                                                    shape: BoxShape.circle,
                                                                                    border: Border.all(
                                                                                      color: Colors.black, 
                                                                                      width: 2, 
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              /*
                                                                                Circulo amarelo
                                                                              */

                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 45, left: 170),
                                                                                child: Container(
                                                                                  width: 13,
                                                                                  height: 13,
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color.fromARGB(255, 255, 230, 0),
                                                                                    shape: BoxShape.circle,
                                                                                    border: Border.all(
                                                                                      color: Colors.black, 
                                                                                      width: 2, 
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              /*
                                                                                Circulo verde
                                                                              */

                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 45, left: 200),
                                                                                child: Container(
                                                                                  width: 13,
                                                                                  height: 13,
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color.fromARGB(255, 55, 255, 0),
                                                                                    shape: BoxShape.circle,
                                                                                    border: Border.all(
                                                                                      color: Colors.black, 
                                                                                      width: 2, 
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },

                                                                      
                                                              style: ElevatedButton.styleFrom(
                                                                padding: EdgeInsets.zero, 
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  side: const BorderSide( 
                                                                    color: Colors.black,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                backgroundColor: Colors.transparent,
                                                                shadowColor: Colors.transparent,
                                                              ).copyWith(
                                                                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                                                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                                                                elevation: WidgetStateProperty.all(0),
                                                              ),
                                                              child: Ink(
                                                                decoration: BoxDecoration(
                                                                  gradient: const LinearGradient(
                                                                    colors: [
                                                                      Color(0xFF1900FF),
                                                                      Colors.black,
                                                                      Color(0xFF1900FF),
                                                                    ],
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  border: Border.all(
                                                                    color: Colors.black,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Salvar",
                                                                    style: GoogleFonts.lato(
                                                                      textStyle: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                          ],
                                                        ),
                                                      ), // Fim do UnconstrainedBox
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.chat_bubble,
                                              color: Colors.white, size: 18),
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
                                      Botão favorito
                                    */

                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          onPressed: () async {
                                            await _controller.toggleFavoriteStatus(
                                              pokemonCode: pokemon.code,
                                              pokemonName: pokemon.name,
                                              isCurrentlyFavorite: isFavorite,
                                            );
                                            setState(() {
                                              _cardsData[pokemon.code] = {
                                                'favorite': !isFavorite,
                                                'comment': comment,
                                              };
                                              _applyFilterAndSort(); // Reordena a lista
                                            });
                                          },
                                          icon: Icon(Icons.star,
                                              color: isFavorite ? Colors.yellow : Colors.white, 
                                              size: 18),
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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const InicioScreen(),
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
                    Icons.star_border,
                    color: Color.fromARGB(255, 255, 255, 255),
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