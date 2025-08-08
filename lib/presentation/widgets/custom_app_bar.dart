// lib/presentation/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Eu adiciono uma nova propriedade para controlar o botão da esquerda.
  final bool showBackButton;

  // O valor padrão de showBackButton é false.
  const CustomAppBar({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 120,
      // Eu uso o 'automaticallyImplyLeading: false' para ter controle total.
      automaticallyImplyLeading: false,
      // Agora o leading depende da minha nova propriedade.
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                print('Menu clicado!');
              },
            ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/app_logo.svg',
            height: 60,
          ),
          const SizedBox(height: 10),
          const Text(
            'RICK AND MORTY API',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () {
            print('Perfil clicado!');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120.0);
}
