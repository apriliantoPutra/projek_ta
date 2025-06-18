import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:mobile_ta/widget/setor_card/setor_card_jemput_proses.dart';
import 'package:mobile_ta/widget/setor_card/setor_card_langsung_baru.dart';
import 'package:mobile_ta/widget/videoCard_widget.dart';
import '../widget/eduCard_widget.dart';

class PetugasBerandaPage extends StatelessWidget {
  final Map<String, dynamic>? akunData;
  final Map<String, dynamic>? profilData;
  const PetugasBerandaPage({Key? key, this.akunData, this.profilData})
    : super(key: key);
  @override
  Widget build(BuildContext) {
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
            //Total Sampah Terkumpul
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF8fd14f),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Sampah Terkumpul',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(height: 20),

                  //Jenis Sampah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jenis Sampah :',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            "14,144,400+",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          Text(
                            "Sampah Botol",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),

                      //Berat Sampah
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Berat Sampah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            "400+ ton",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          Text(
                            "Sampah Lainnya",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Setor Terbaru",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Lainnya",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Column(
                  //   children: [
                  //     SetorCardJemputProses(),
                  //     SetorCardJemputProses(),
                  //     SetorCardJemputProses(),
                  //   ],
                  // ),
                ],
              ),
            ),

            //Konten Edukasi
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF8fd14f),
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
                    children: [
                      Text(
                        "Edukasi Terbaru",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Lainnya",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 250,
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
                        final title = [
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
                          title: title[index],
                          date: dates[index],
                          onTap: () {
                            print("Menonton : ${title[index]}");
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    // spacing: 2, // Jarak horizontal antar card
                    // runSpacing: 2, // Jarak vertikal antar baris
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
