import 'package:flutter/material.dart';

class WargaSetorLangsung extends StatelessWidget {
  const WargaSetorLangsung({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _tanggalController = TextEditingController();
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
          'Setor Langsung',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    'Setor Langsung',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Setor Langsung adalah layanan penyetoran dan penukaran sampah menjadi uang yang dilakukan secara langsung di lokasi Bank Sampah.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Label tanggal
            Text(
              "Tanggal Penyetoran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Input tanggal
            Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    // Format tanggal: dd/MM/yyyy
                    String formattedDate =
                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                        "${pickedDate.year}";
                    _tanggalController.text = formattedDate;
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tanggal",
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Label lokasi
            Text(
              "Lokasi Penyetoran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Input lokasi
            Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                initialValue: "Bank Sampah Kecamatan Tembalang",
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Lokasi",
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Anda hanya dapat melakukan satu kali booking penyetoran. Gunakan tombol 'Ubah' untuk mengganti waktu, atau 'Batalkan' jika ingin membatalkan layanan.",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Aksi konfirmasi
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Selanjutnya"),
            ),
            // Tombol Konfirmasi dan Batalkan
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           // Aksi konfirmasi
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.greenAccent.shade400,
            //           padding: const EdgeInsets.symmetric(vertical: 14),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //         child: const Text("Konfirmasi"),
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           // Aksi batalkan
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.orange,
            //           foregroundColor: Colors.white,
            //           padding: const EdgeInsets.symmetric(vertical: 14),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //         child: const Text("Batalkan"),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
