
import '../screens/detail_screen.dart';
import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';


class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // Eu envolvo meu Card com um InkWell pra ele ser clicável e ter o efeito de splash.
    return InkWell(
      onTap: () {
  // Eu uso o Navigator para empurrar uma nova rota (tela) na pilha.
  Navigator.push(
    context,
    MaterialPageRoute(
      // A nova tela a ser construída é a DetailScreen.
      // Eu passo o objeto 'character' completo para o construtor dela.
      builder: (context) => DetailScreen(character: character),
    ),
  );
},
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // O Stack me deixa colocar o texto em cima da imagem.
        child: Stack(
          children: [
            // A imagem do personagem, que cobre todo o card.
            Image.network(
              character.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.error)),
                );
              },
            ),

            // Eu posiciono o nome na parte de baixo.
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}