import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/petugas/petugas_detail_konten_page.dart';

import 'package:mobile_ta/warga/artikel/detail_page.dart';
import 'package:mobile_ta/widget/eduCard_widget.dart';

class PetugasKontenPage extends StatefulWidget {
  const PetugasKontenPage({super.key});

  @override
  State<PetugasKontenPage> createState() => _PetugasKontenPageState();
}

class _PetugasKontenPageState extends State<PetugasKontenPage> {
  late Future<List<dynamic>> _artikelList;

  Future<List<dynamic>> fetchArtikel() async {
    final response = await http.get(Uri.parse('$baseUrl/artikel'));

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
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          'Artikel Edukasi',
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
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children:
                        artikelList.map((artikel) {
                          return EduCard(
                            imageUrl: artikel['gambar_url'],
                            title: artikel['judul_artikel'],
                            date: formatDate(artikel['created_at']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PetugasDetailKontenPage(
                                        id: artikel['id'],
                                      ),
                                ),
                              );
                            },
                          );
                        }).toList(),
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
