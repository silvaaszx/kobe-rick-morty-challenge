// lib/presentation/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'locations_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_app_bar.dart'; // Preciso da AppBar aqui agora

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screenOptions = <Widget>[
    HomeScreen(),
    LocationsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Este é o único Scaffold do app para esta seção.
    return Scaffold(
      // A AppBar agora vive aqui, no topo de tudo.
      appBar: const CustomAppBar(),
      // O Drawer também vive aqui.
      drawer: AppDrawer(
  onItemSelected: _onItemTapped,
  selectedIndex: _selectedIndex,
),
      // O corpo muda de acordo com a seleção do menu.
      body: _screenOptions.elementAt(_selectedIndex),
    );
  }
}
