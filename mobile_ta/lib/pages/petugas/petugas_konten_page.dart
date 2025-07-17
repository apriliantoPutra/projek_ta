import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_ta/pages/petugas/artikel/petugas_detail_artikel_page.dart';
import 'package:mobile_ta/pages/petugas/artikel/petugas_kumpulan_artikel_page.dart';
import 'package:mobile_ta/pages/petugas/video/petugas_detail_video_page.dart';
import 'package:mobile_ta/pages/petugas/video/petugas_kumpulan_video_page.dart';
import 'package:mobile_ta/widget/eduCard_widget.dart';
import 'package:mobile_ta/widget/videoCard_widget.dart';

class PetugasKontenPage extends StatelessWidget {
  final List<dynamic> artikelList;
  final List<dynamic> videoList;
  const PetugasKontenPage({
    Key? key,
    required this.artikelList,
    required this.videoList,
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
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color(0xFF128d54),
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
              width: double.infinity,
              // height: 70,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6BBE44), Color(0xFF128d54)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text.rich(
                TextSpan(
                  text:
                      "Baca artikel dan tonton video seru tentang cara mudah mengelola sampah. Siap jadi ",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: "#PahlawanLingkungan?",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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
                    color: Colors.green.withOpacity(0.10),
                    blurRadius: 12,
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
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF128d54),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetugasKumpulanVideoPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Lainnya",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF128d54),
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
                                    (_) => PetugasDetailVideoPage(
                                      videoId: video['id'],
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Artikel Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Artikel Terbaru",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF128d54),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PetugasKumpulanArtikelPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Lainnya",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF128d54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: artikelList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final artikel = artikelList[index];
                        return EduCard(
                          imageUrl: artikel['gambar_url'],
                          title: artikel['judul_artikel'],
                          date: artikel['tanggal_format'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PetugasDetailArtikelPage(
                                      id: artikel['id'],
                                    ),
                              ),
                            );
                          },
                        );
                      },
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
}
