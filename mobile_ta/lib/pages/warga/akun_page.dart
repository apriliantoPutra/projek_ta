import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/pages/warga/histori_saldo/kumpulan_histori_saldo_page.dart';
import 'package:mobile_ta/pages/warga/info_page.dart';
import 'package:mobile_ta/pages/warga/notifikasi_page.dart';
import 'package:mobile_ta/pages/warga/tarik_saldo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profil_page.dart';
import '../auth/login_page.dart';

class WargaAkunPage extends StatefulWidget {
  final Map<String, dynamic>? akunData;
  final Map<String, dynamic>? profilData;
  final Map<String, dynamic>? saldoData;

  const WargaAkunPage({
    Key? key,
    this.akunData,
    this.profilData,
    this.saldoData,
  }) : super(key: key);

  @override
  State<WargaAkunPage> createState() => _WargaAkunPageState();
}

class _WargaAkunPageState extends State<WargaAkunPage> {
  int jumlahPermintaanTarikSaldo = 0;

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      await prefs.remove('token');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'Gagal logout';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<int> fetchPermintaanTarikSaldo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint('Token tidak ditemukan');
      return 0;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/permintaan-tarik-saldo'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'] is int ? jsonData['data'] : 0;
    } else {
      throw Exception('Gagal memuat data permintaan tarik saldo');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPermintaanTarikSaldo().then((value) {
      setState(() {
        jumlahPermintaanTarikSaldo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final akunData = widget.akunData;
    final profilData = widget.profilData;
    final saldoData = widget.saldoData;
    final bool isTarikSaldoAktif =
        saldoData != null &&
        jumlahPermintaanTarikSaldo < saldoData['total_saldo'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Akun Saya',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      (profilData?['gambar_pengguna'] ?? '').isNotEmpty
                          ? profilData!['gambar_url']
                          : 'https://i.pinimg.com/736x/8a/e9/e9/8ae9e92fa4e69967aa61bf2bda967b7b.jpg',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    akunData?['username'] ?? 'Memuat...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  Text(
                    akunData?['email'] ?? 'Memuat...',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  WargaEditProfilPage(profilData: profilData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Edit Profil"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Saldo Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Saldo Saya",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "Permintaan Saldo",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        saldoData != null
                            ? 'Rp ${saldoData['total_saldo']}'
                            : 'Memuat...',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Rp $jumlahPermintaanTarikSaldo',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KumpulanHistoriSaldoPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Histori Saldo"),
                      ),
                      ElevatedButton(
                        onPressed:
                            isTarikSaldoAktif
                                ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => WargaTarikSaldoPage(
                                            no_hp:
                                                profilData?['no_hp_pengguna'],
                                            saldo: saldoData,
                                            permintaanSaldo:
                                                jumlahPermintaanTarikSaldo,
                                          ),
                                    ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isTarikSaldoAktif
                                  ? Colors.white
                                  : Colors.grey.shade400,
                          foregroundColor:
                              isTarikSaldoAktif
                                  ? Colors.green.shade900
                                  : Colors.grey.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: isTarikSaldoAktif ? 2 : 0,
                        ),
                        child: Text("Tarik Saldo"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Menu lainnya
            Column(
              children: [
                _buildMenuItem(Icons.info, "Info", iconColor: Colors.deepPurpleAccent, onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WargaInfoPage()),
                    );
                },),
                _buildMenuItem(
                  Icons.mail_outline,
                  "Notifikasi",
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WargaNotifikasiPage()),
                    );
                  },
                ),

                _buildMenuItem(
                  Icons.logout,
                  "Logout",
                  iconColor: Colors.red,
                  onTap: () => logout(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.green.shade900),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.green.shade900,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
