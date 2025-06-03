import 'package:flutter/material.dart';

class WargaHistoriSetor extends StatelessWidget {
  const WargaHistoriSetor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Histori Setor Sampah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}