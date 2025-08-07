// lib/presentation/screens/detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';
import '../../data/services/character_service.dart'; // Preciso do serviço aqui agora

// 1. Eu transformo a tela em um StatefulWidget
class DetailScreen extends StatefulWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // 2. Crio uma instância do serviço e uma variável para o resultado do episódio
  final CharacterService _service = CharacterService();
  late Future<Map<String, dynamic>> _episodeFuture;

  @override
  void initState() {
    super.initState();
    // 3. Assim que a tela inicia, eu chamo o método para buscar os dados do episódio
    _episodeFuture = _service.getDataFromUrl(widget.character.firstEpisodeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.character.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: widget.character.imageUrl,
                  placeholder: (context, url) => const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF5C6BC0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.character.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatusInfo(widget.character.status, widget.character.species),
                    const SizedBox(height: 24),
                    _buildLabeledInfo('GÊNERO:', widget.character.gender),
                    const SizedBox(height: 16),
                    _buildLabeledInfo('ÚLTIMA LOCALIZAÇÃO CONHECIDA:', widget.character.locationName),
                    const SizedBox(height: 16),
                    
                    // 4. AQUI ESTÁ A MÁGICA! Eu uso um FutureBuilder para exibir o nome do episódio
                    FutureBuilder<Map<String, dynamic>>(
                      future: _episodeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Enquanto carrega, mostro um indicador
                          return _buildLabeledInfo('PRIMEIRA APARIÇÃO EM:', 'Carregando...');
                        } else if (snapshot.hasError) {
                          return _buildLabeledInfo('PRIMEIRA APARIÇÃO EM:', 'Erro');
                        } else if (snapshot.hasData) {
                          // Quando os dados chegam, eu pego o nome do episódio do JSON
                          final episodeName = snapshot.data?['name'] ?? 'Desconhecido';
                          return _buildLabeledInfo('PRIMEIRA APARIÇÃO EM:', episodeName);
                        } else {
                          return _buildLabeledInfo('PRIMEIRA APARIÇÃO EM:', 'N/A');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... os widgets de construção de UI continuam os mesmos ...
  Widget _buildStatusInfo(String status, String species) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'alive':
        statusColor = Colors.greenAccent;
        break;
      case 'dead':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$status - $species',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildLabeledInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
