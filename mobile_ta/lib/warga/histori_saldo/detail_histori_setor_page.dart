import 'package:flutter/material.dart';

class DetailHistoriSetorPage extends StatefulWidget {
  const DetailHistoriSetorPage({super.key});

  @override
  State<DetailHistoriSetorPage> createState() => _DetailHistoriSetorPageState();
}

class _DetailHistoriSetorPageState extends State<DetailHistoriSetorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Setor Sampah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
