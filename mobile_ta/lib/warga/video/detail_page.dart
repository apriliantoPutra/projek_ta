import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mobile_ta/constants/constants.dart' as constants;

class WargaDetailVideoPage extends StatefulWidget {
  final int videoId;

  const WargaDetailVideoPage({super.key, required this.videoId});

  @override
  State<WargaDetailVideoPage> createState() => _WargaDetailVideoPageState();
}

class _WargaDetailVideoPageState extends State<WargaDetailVideoPage> {
  late final Player _player;
  late final VideoController _controller;
  bool _isLoading = true;
  bool _videoReady = false;
  bool _hasError = false;

  String _judul = '';
  String _deskripsi = '';
  String _tanggal = '';
  String _videoUrl = '';

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    fetchVideoDetail();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> fetchVideoDetail() async {
    try {
      final response = await http.get(
        Uri.parse('${constants.baseUrl}/video/${widget.videoId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];

        _judul = data['judul_video'];
        _deskripsi = data['deskripsi_video'];
        _tanggal = DateFormat(
          'd MMMM yyyy',
          'id_ID',
        ).format(DateTime.parse(data['created_at']));
        _videoUrl = data['video_url'];

        if (_videoUrl.isEmpty || !_videoUrl.startsWith('http')) {
          throw Exception("Invalid video URL: $_videoUrl");
        }

        await _player.open(Media(_videoUrl));
        await _player.pause(); // 🔴 Agar tidak autoplay

        setState(() {
          _isLoading = false;
          _videoReady = true;
        });
      } else {
        throw Exception('Gagal memuat detail video');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edukasi Video',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 10),
                    Text('Gagal memuat video.'),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child:
                          _videoReady
                              ? Video(controller: _controller)
                              : const Center(
                                child: CircularProgressIndicator(),
                              ),
                    ),
                    const SizedBox(height: 20),

                    // Judul
                    Text(
                      _judul,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Tanggal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _tanggal,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Deskripsi
                    Text(
                      _deskripsi,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
    );
  }
}
