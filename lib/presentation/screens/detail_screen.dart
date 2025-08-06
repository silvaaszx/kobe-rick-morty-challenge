// lib/presentation/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // Eu uso um tema para pegar as cores e fontes padrão.
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // A seta de "voltar" já aparece automaticamente.
        title: Text(character.name),
      ),
      // Uso um SingleChildScrollView para garantir que a tela role em celulares menores.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A imagem do personagem no topo.
            Image.network(
              character.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),

            // O nome do personagem como um título grande.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                character.name,
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24.0),

            // Eu crio um widget reutilizável para cada linha de informação.
            _buildInfoRow(
              context: context,
              icon: Icons.monitor_heart,
              label: 'Status',
              value: character.status,
            ),
            _buildInfoRow(
              context: context,
              icon: Icons.psychology,
              label: 'Espécie',
              value: character.species,
            ),
            _buildInfoRow(
              context: context,
              icon: Icons.transgender,
              label: 'Gênero',
              value: character.gender,
            ),
            _buildInfoRow(
              context: context,
              icon: Icons.public,
              label: 'Origem',
              value: character.originName,
            ),
            _buildInfoRow(
              context: context,
              icon: Icons.location_on,
              label: 'Última Localização',
              value: character.locationName,
            ),
             _buildInfoRow(
              context: context,
              icon: Icons.movie,
              label: 'Primeira Aparição',
              value: 'Episódio (a ser buscado)', // Placeholder
            ),
          ],
        ),
      ),
    );
  }

  // Este é um método privado para construir cada linha de detalhe.
  // Isso evita repetição de código.
  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.secondary, size: 20),
          const SizedBox(width: 16),
          Text(
            '$label: ',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          // O Expanded garante que o valor ocupe o resto do espaço, quebrando a linha se necessário.
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
