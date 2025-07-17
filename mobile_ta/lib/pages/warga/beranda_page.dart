import 'package:flutter/material.dart';
import 'package:mobile_ta/pages/warga/artikel/detail_page.dart';
import 'package:mobile_ta/pages/warga/chatbot_page.dart';
import 'package:mobile_ta/pages/warga/histori_setor/kumpulan_histori_setor_page.dart';
import 'package:mobile_ta/pages/warga/info_page.dart';
import 'package:mobile_ta/pages/warga/kalkulator/kalkulator_setor_sampah_page.dart';
import 'package:mobile_ta/pages/warga/video/detail_page.dart';
import 'package:mobile_ta/widget/videoCard_widget.dart';
import '../../widget/eduCard_widget.dart';

class WargaBerandaPage extends StatelessWidget {
  final Map<String, dynamic>? akunData;
  final Map<String, dynamic>? profilData;
  final Map<String, dynamic>? saldoData;
  final List<dynamic> artikelList;
  final List<dynamic> videoList;

  final String? totalSampah;

  const WargaBerandaPage({
    Key? key,
    this.akunData,
    this.profilData,
    this.saldoData,
    required this.artikelList,
    required this.videoList,
    this.totalSampah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    (profilData?['gambar_pengguna'] ?? '').isNotEmpty
                        ? profilData!['gambar_url']
                        : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg',
                  ),
                ),

                SizedBox(width: 10),
                Text(
                  akunData?['username'] ?? 'Memuat...',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff8fd14f),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Sampah Terkumpul",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    totalSampah != null ? '$totalSampah kg' : 'Memuat...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Total Saldo",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    saldoData != null
                        ? 'Rp ${saldoData!['total_saldo']}'
                        : 'Memuat...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Fitur Lain",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _menuItem(
                        Icons.calculate,
                        "Kalkulator",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KalkulatorSetorSampahPage(),
                            ),
                          );
                        },
                      ),
                      _menuItem(
                        Icons.history,
                        "Histori",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KumpulanHistoriSetorPage(),
                            ),
                          );
                        },
                      ),
                      _menuItem(
                        Icons.info_outline,
                        "Info",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WargaInfoPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff8fd14f),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edukasi Terbaru",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aksi saat ditekan
                        },
                        child: Text(
                          "Lainnya",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: videoList.length,
                      itemBuilder: (context, index) {
                        final video = videoList[index];
                        return VideoCard(
                          imageUrl:
                              'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg',
                          title: video['judul_video'] ?? '',
                          date: video['tanggal_format'] ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => WargaDetailVideoPage(
                                      videoId: video['id'],
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 5, // Jarak horizontal antar card
                    runSpacing: 5, // Jarak vertikal antar baris
                    children:
                        artikelList.map((artikel) {
                          return EduCard(
                            imageUrl: artikel['gambar_url'],
                            title: artikel['judul_artikel'],
                            date: artikel['tanggal_format'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WargaDetailArtikelPage(
                                        id: artikel['id'],
                                      ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotPage()),
              );
            },
            backgroundColor: Colors.green,
            tooltip: 'Buka Chatbot',
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
            ), // Icon chatbot AI
          ),
          const SizedBox(height: 16), // Jarak dari bawah
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Warna bayangan
                  spreadRadius: 1, // Menyebar keluar
                  blurRadius: 8, // Seberapa kabur/sharp
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
