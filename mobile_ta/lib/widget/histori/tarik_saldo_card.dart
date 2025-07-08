import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ta/warga/histori_saldo/detail_histori_saldo_page.dart';

class TarikSaldoCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const TarikSaldoCard({required this.data, super.key});

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Colors.orange;
      case 'terima':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  String formatMetode(String metode) {
    final lower = metode.toLowerCase();
    if (lower == 'dana' || lower == 'shopeepay') {
      return 'E-Wallet (${_capitalize(metode)})';
    } else if (lower == 'bni' || lower == 'bca') {
      return 'Transfer Bank (${metode.toUpperCase()})';
    }
    return _capitalize(metode);
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final jumlah = data['jumlah_saldo'] ?? 0;
    final status = data['status'] ?? '';
    final metode = data['metode'] ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff8fd14f),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCurrency(jumlah),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  status,
                  style: TextStyle(
                    color: getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatMetode(metode),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Arrow
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailHistoriSaldoPage(id: data['id']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
