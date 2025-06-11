import 'package:flutter/material.dart';
import 'package:mobile_ta/widget/petugas_main_widget.dart';

class PetugasSetorLangsungSelesai extends StatelessWidget {
  const PetugasSetorLangsungSelesai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const PetugasMainWrapper(initialIndex: 1),
                ),
                (Route<dynamic> route) => false,
              ),
        ),
        title: Text(
          "Setor Langsung Sampah",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg",
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Nama Penyetor",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8FD14F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Progress bar
                  Stack(
                    children: [
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(height: 32, color: Colors.blue),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(height: 32, color: Colors.green),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Positioned.fill(
                        child: Center(
                          child: Text(
                            '11kg',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Legend sampah
                  Row(
                    children: [
                      _buildLegend(
                        color: Colors.orange,
                        label: "Sampah Kardus",
                        weight: "2kg",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLegend(
                        color: Colors.blue,
                        label: "Sampah Kaleng",
                        weight: "7kg",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLegend(
                        color: Colors.green,
                        label: "Sampah Botol Plastik",
                        weight: "1kg",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLegend(
                        color: Colors.teal,
                        label: "Sampah Kertas",
                        weight: "1kg",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Estimasi Harga",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Rp50.000",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "Nama Petugas",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Petugas Krisna",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama Bank Sampah",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  // SizedBox(height: 8),
                  Text(
                    "Alamat Bank Sampah: Jl. Lorem ipsum dolor sit amet, consectetur adipiscing elit, Semarang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend({
    required Color color,
    required String label,
    required String weight,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            weight,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
