import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/warga/video/detail_page.dart';
import 'package:mobile_ta/widget/videoCard_widget.dart';

class WargaKumpulanVideoPage extends StatefulWidget {
  const WargaKumpulanVideoPage({super.key});

  @override
  State<WargaKumpulanVideoPage> createState() => _WargaKumpulanVideoPageState();
}

class _WargaKumpulanVideoPageState extends State<WargaKumpulanVideoPage> {
  late Future<List<dynamic>> _videoList;

  Future<List<dynamic>> fetchVideo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/video'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Gagal memuat data edukasi video');
    }
  }

  String formatDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _videoList = fetchVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edukasi Video',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _videoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          }

          final videoList = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade100,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children:
                        videoList.map((edukasi_video) {
                          return VideoCard(
                            imageUrl:
                                'https://i.pinimg.com/736x/2d/d3/79/2dd379968693700ec12af8f1974b491e.jpg',
                            title: edukasi_video['judul_video'],
                            date: formatDate(edukasi_video['created_at']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WargaDetailVideoPage(
                                        videoId: edukasi_video['id'],
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
