import 'package:flutter/material.dart';
import 'package:mobile_ta/widget/videoCard_widget.dart';
import '../widget/eduCard_widget.dart';

class WargaEdukasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              alignment: Alignment.center, // Menengahkan isi
              child: Text(
                "Edukasi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
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
                          color: Colors.green.shade800,
                        ),
                      ),
                      Text(
                        "Lainnya",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final imageUrls = [
                          'https://i.pinimg.com/736x/89/5c/c5/895cc5d9dcf9bcc8fa4a717ffbf9b9b1.jpg',
                          'https://i.pinimg.com/736x/65/f7/86/65f7860b848ee36cb272962ca0b540b2.jpg',
                          'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg',
                          'https://i.pinimg.com/736x/d8/a8/16/d8a816495548996b07e824a9d93fc951.jpg',
                          'https://i.pinimg.com/736x/dd/02/48/dd024873e1a51d05f8ce95776fda8ca1.jpg',
                        ];

                        final titles = [
                          'Video Edukasi 1',
                          'Video Edukasi 2',
                          'Video Edukasi 3',
                          'Video Edukasi 4',
                          'Video Edukasi 5',
                        ];

                        final dates = [
                          'Mei 2025',
                          'April 2025',
                          'Maret 2025',
                          'Februari 2025',
                          'Januari 2025',
                        ];

                        return VideoCard(
                          imageUrl: imageUrls[index],
                          title: titles[index],
                          date: dates[index],
                          onTap: () {
                            // Tindakan saat tombol "Tonton Video" ditekan
                            print('Menonton: ${titles[index]}');
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 12, // Jarak horizontal antar card
                    runSpacing: 12, // Jarak vertikal antar baris
                    children: [
                      EduCard(
                        imageUrl:
                            'https://i.pinimg.com/736x/89/5c/c5/895cc5d9dcf9bcc8fa4a717ffbf9b9b1.jpg',
                        title: 'Menjaga Lingkungan',
                        date: '12 Mei 2025',
                        onTap: () {
                          // Aksi ketika artikel dibaca
                        },
                      ),
                      EduCard(
                        imageUrl:
                            'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg',
                        title: 'Pentingnya Daur Ulang',
                        date: '10 Mei 2025',
                        onTap: () {
                          // Aksi ketika artikel dibaca
                        },
                      ),
                      EduCard(
                        imageUrl:
                            'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg',
                        title: 'Sampah Anorganik',
                        date: '6 Mei 2025',
                        onTap: () {
                          // Aksi ketika artikel dibaca
                        },
                      ),
                    ],
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
