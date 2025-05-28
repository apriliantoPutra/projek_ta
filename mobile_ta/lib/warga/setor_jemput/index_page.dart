import 'package:flutter/material.dart';
import 'package:mobile_ta/warga/setor_jemput/konfirmasi_page.dart';

class WargaSetorJemput extends StatefulWidget {
  const WargaSetorJemput({super.key});

  @override
  State<WargaSetorJemput> createState() => _WargaSetorJemputState();
}

class _WargaSetorJemputState extends State<WargaSetorJemput> {
  List<Map<String, TextEditingController>> _jenisSampahList = [
    {'jenis': TextEditingController(), 'berat': TextEditingController()},
  ];

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
          'Setor Jemput',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(11),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Setor Jemput',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Setor Jemput adalah layanan penjemputan sampah ke rumah pengguna oleh petugas Bank Sampah, dengan tambahan biaya sebesar Rp4.000 per kilometer.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tambahkan label kolom
                    Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Jenis Sampah',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Berat (kg)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    ..._jenisSampahList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: item['jenis'],
                                decoration: const InputDecoration(
                                  hintText: 'Jenis sampah',
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: item['berat'],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Berat',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _jenisSampahList.add({
                                'jenis': TextEditingController(),
                                'berat': TextEditingController(),
                              });
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.green),
                          label: Text(
                            'Tambah Jenis Sampah',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WargaKonfirmasiSetorJemputPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Selanjutnya',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
