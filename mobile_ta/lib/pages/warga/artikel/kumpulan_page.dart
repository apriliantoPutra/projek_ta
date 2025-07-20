import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';

import 'package:mobile_ta/pages/warga/artikel/detail_page.dart';
import 'package:mobile_ta/widget/eduCard_widget.dart';

class WargaKumpulanArtikelPage extends StatefulWidget {
  const WargaKumpulanArtikelPage({super.key});

  @override
  State<WargaKumpulanArtikelPage> createState() =>
      _WargaKumpulanArtikelPageState();
}

class _WargaKumpulanArtikelPageState extends State<WargaKumpulanArtikelPage> {
  late Future<List<dynamic>> _artikelList;

  Future<List<dynamic>> fetchArtikel() async {
    final response = await http.get(Uri.parse('${dotenv.env['URL']}/artikel'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data artikel');
    }
  }

  String formatDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _artikelList = fetchArtikel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8fd14f),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edukasi Artikel',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _artikelList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          }

          final artikelList = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio:
                              0.75, // Sesuaikan ini sesuai ukuran EduCard
                        ),
                    itemCount: artikelList.length,
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
                                  (context) =>
                                      WargaDetailArtikelPage(id: artikel['id']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
