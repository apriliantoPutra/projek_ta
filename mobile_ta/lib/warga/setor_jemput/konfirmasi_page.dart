import 'package:flutter/material.dart';

class WargaKonfirmasiSetorJemputPage extends StatelessWidget {
  const WargaKonfirmasiSetorJemputPage({super.key});

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
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informasi Layanan
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
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

              // Judul Jenis dan Berat
              const Text(
                'Jenis dan Berat Sampah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Box jenis dan berat + indikator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Bar indikator total
                    Stack(
                      children: [
                        // Background
                        Container(
                          height: 24, // ✅ Lebih tinggi
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[300],
                          ),
                        ),
                        // Progress bar per kategori
                        Row(
                          children: [
                            Expanded(
                              flex: 2, // Sampah Kardus
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7, // Sampah Botol Kaca
                              child: Container(height: 24, color: Colors.blue),
                            ),
                            Expanded(
                              flex: 1, // Sampah Botol Plastik
                              child: Container(height: 24, color: Colors.green),
                            ),
                            Expanded(
                              flex: 1, // Sampah Kertas
                              child: Container(
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Centered Text
                        const Positioned.fill(
                          child: Center(
                            child: Text(
                              '11kg',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    // Daftar sampah
                    Row(
                      children: const [
                        Icon(Icons.square, color: Colors.orange),
                        SizedBox(width: 6),
                        Expanded(child: Text('Sampah Kardus')),
                        Text('2kg'),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.square, color: Colors.blue),
                        SizedBox(width: 6),
                        Expanded(child: Text('Sampah Botol Kaca')),
                        Text('7kg'),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.square, color: Colors.green),
                        SizedBox(width: 6),
                        Expanded(child: Text('Sampah Botol Plastik')),
                        Text('1kg'),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.square, color: Colors.teal),
                        SizedBox(width: 6),
                        Expanded(child: Text('Sampah Kertas')),
                        Text('1.4kg'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Estimasi Insentif
              const Text(
                'Estimasi Insentif',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimasi harga sampah anda'),
                        Text('Rp 40.000'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Biaya Layanan'), Text('-Rp 8.000')],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Perkiraan Insentif',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp 32.000',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Nama Bank Sampah
              const Text(
                'Nama Bank Sampah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Alamat Bank Sampah: Jl. Lorem ipsum dolor sit amet, consectetur adipiscing elit, Semarang',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://i.pinimg.com/736x/b0/79/09/b079096855c0edbaba47d93c67f18853.jpg', // Ganti dengan path gambar peta kamu
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),

              // Tombol
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Konfirmasi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Batalkan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
