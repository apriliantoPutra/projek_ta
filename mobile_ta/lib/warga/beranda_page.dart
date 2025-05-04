import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Sampah Terkumpul", style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("14,114,400kg Sampah Botol", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Rp300.000,-", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Fitur Lain", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _menuItem(Icons.calculate, "Kalkulator"),
              _menuItem(Icons.history, "Histori"),
              _menuItem(Icons.info_outline, "Info"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center),
      ],
    );
  }
}
