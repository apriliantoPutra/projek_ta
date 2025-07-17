import 'package:flutter/material.dart';

class NotifikasiCard extends StatelessWidget {
  const NotifikasiCard({super.key});

  @override
  Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  
    return Container(
      width: width * 0.95,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff8fd14f),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Informasi utama
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Setor Jemput",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '13/13/2025',
                style: TextStyle(fontSize: width * 0.035, color: Colors.white),
              ),
            ],
          ),
          // Icon panah ke kanan
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              
            },
          ),
        ],
      ),
    );
  }
}