import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WargaDetailVideoPage extends StatefulWidget {
  final int videoId;

  const WargaDetailVideoPage({super.key, required this.videoId});

  @override
  State<WargaDetailVideoPage> createState() => _WargaDetailVideoPageState();
}

class _WargaDetailVideoPageState extends State<WargaDetailVideoPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isLoading = true;

  String _judul = '';
  String _deskripsi = '';
  String _tanggal = '';
  String _videoUrl = '';

  Future<void> fetchVideoDetail() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/video/${widget.videoId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        _judul = data['judul_video'];
        _deskripsi = data['deskripsi_video'];
        _tanggal = DateFormat(
          'd MMMM yyyy',
          'id_ID',
        ).format(DateTime.parse(data['created_at']));
        _videoUrl = data['video_url'];
      });

      _controller =
          VideoPlayerController.network(_videoUrl)
            ..addListener(() {
              if (_controller.value.hasError) {
                print('❌ Video Error: ${_controller.value.errorDescription}');
              }
            })
            ..initialize()
                .then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                })
                .catchError((e) {
                  print('❌ Gagal inisialisasi video: $e');
                });

      _controller.setLooping(true);
    } else {
      throw Exception('Gagal memuat detail video');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVideoDetail();
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
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
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Video Player
                    _controller.value.isInitialized
                        ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(_controller),
                              if (!_isPlaying)
                                Container(
                                  color: Colors.black45,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.play_circle_fill,
                                      size: 64,
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePlay,
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                ),
                              ),
                            ],
                          ),
                        )
                        : Container(
                          height: 200,
                          color: Colors.black12,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    const SizedBox(height: 20),

                    // Judul Video
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

                    // Tanggal Rilis
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

                    // Deskripsi Video
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
