import 'package:flutter/material.dart';
import 'package:mobile_ta/constants/constants.dart';
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
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;

  String _judul = '';
  String _deskripsi = '';
  String _tanggal = '';
  String _videoUrl = '';

  Future<void> fetchVideoDetail() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/video/${widget.videoId}'),
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

        print('✅ Video URL: $_videoUrl');

        if (_videoUrl.isEmpty || !_videoUrl.startsWith('http')) {
          throw Exception("Invalid video URL: $_videoUrl");
        }

        _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl));

        await _controller!.initialize();

        _controller!.setLooping(true);
        setState(() {
          _isLoading = false;
        });

        // Jangan auto-play
      } else {
        throw Exception('Gagal memuat detail video');
      }
    } catch (e) {
      print('❌ Gagal inisialisasi video: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVideoDetail();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
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
                    if (_controller != null && _controller!.value.isInitialized)
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_controller!),
                            if (!_isPlaying)
                              GestureDetector(
                                onTap: _togglePlay,
                                child: Container(
                                  color: Colors.black45,
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        color: Colors.black12,
                        child: const Center(
                          child: Text(
                            "Video tidak tersedia",
                            style: TextStyle(color: Colors.grey),
                          ),
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
