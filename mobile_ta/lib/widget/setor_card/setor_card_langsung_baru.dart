import 'package:flutter/material.dart';
import 'package:mobile_ta/petugas/petugas_setor_jemput_baru.dart';
import 'package:mobile_ta/petugas/petugas_setor_langsung_baru.dart';

class SetorCardLangsungBaru extends StatelessWidget {
  const SetorCardLangsungBaru({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xff8fd14f),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6), // Jarak antar box
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ), // Jarak antara border dan konten
        decoration: BoxDecoration(
          color: Color(0xFF8fd14f),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Avatar di tengah
          children: [
            CircleAvatar(
              radius: 20, // Perbesar avatar
              backgroundImage: NetworkImage(
                "https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg",
              ),
            ),
            SizedBox(width: 10), // Jarak antara avatar dan teks
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Teks di tengah
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "maryserran",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Setor Langsung",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Spacer(), // Memberi jarak fleksibel antara teks dan tanggal
            Text(
              "Senin, 14-04-2025",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Mengubah warna teks menjadi putih
              ),
            ),
            SizedBox(width: 5), // Jarak sebelum icon
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ), // Arah kanan
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetugasSetorLangsungBaru(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
