import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ta/models/notification_model.dart';
import 'package:mobile_ta/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_ta/widget/notifikasi_card.dart';

class WargaNotifikasiPage extends StatelessWidget {
  const WargaNotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF128d54)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Setor Langsung',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color(0xFF128d54),
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<NotificationModel>>(
          future: NotificationService().fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Gagal memuat notifikasi'));
            }

            final notifs = snapshot.data ?? [];

            if (notifs.isEmpty) {
              return const Center(child: Text('Belum ada notifikasi'));
            }

            return ListView.builder(
              itemCount: notifs.length,
              itemBuilder: (context, index) {
                final notif = notifs[index];
                return NotifikasiCard(
                  title: notif.title,
                  date: DateFormat('dd/MM/yyyy – HH:mm').format(notif.sentAt),
                  body: notif.body,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
