import 'package:act_autonoma/screens/NotasScreen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Gastos")),
      body: const NotasScreen(),
    );
  }
}
