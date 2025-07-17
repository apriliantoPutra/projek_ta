import 'package:flutter/material.dart';
import 'package:mobile_ta/pages/warga/artikel/detail_page.dart';
import 'package:mobile_ta/pages/warga/artikel/kumpulan_page.dart';
import 'package:mobile_ta/pages/warga/video/detail_page.dart';
import 'package:mobile_ta/pages/warga/video/kumpulan_page.dart';
import 'package:mobile_ta/widget/videoCard_widget.dart';
import '../../widget/eduCard_widget.dart';

class WargaEdukasiPage extends StatelessWidget {
  final Map<String, dynamic>? akunData;
  final List<dynamic> artikelList;
  final List<dynamic> videoList;
  const WargaEdukasiPage({
    Key? key,
    required this.artikelList,
    required this.videoList,
    this.akunData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Konten Edukasi",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              // height: 100,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff8fd14f),
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center, // Menengahkan isi
              child: Text.rich(
                TextSpan(
                  text:
                      "Baca artikel dan tonton video seru tentang cara mudah mengelola sampah. Siap jadi ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: "#PahlawanLingkungan?",
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 16),
            Container(
              // margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                        "Video Terbaru",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8fd14f),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WargaKumpulanVideoPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Lainnya",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8fd14f),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Artikel Terbaru",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8fd14f),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WargaKumpulanArtikelPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Lainnya",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8fd14f),
                          ),
                        ),
                      ),
                    ],
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
    );
  }
}
