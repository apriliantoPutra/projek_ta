import 'package:flutter/material.dart';
import 'package:mobile_ta/pages/warga/setor_langsung/detail_page.dart';

class WargaSetorLangsung extends StatefulWidget {
  
  const WargaSetorLangsung({super.key});

  @override
  State<WargaSetorLangsung> createState() => _WargaSetorLangsungState();
}

class _WargaSetorLangsungState extends State<WargaSetorLangsung> {
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

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
          'Setor Langsung',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              Text(
                "Catatan Petugas (Opsional)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              // Input catatan
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: _catatanController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Masukkan catatan untuk petugas...",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WargaDetailSetorLangsung(
                            tanggal: _tanggalController.text,
                            catatan:
                                _catatanController.text.isNotEmpty
                                    ? _catatanController.text
                                    : null,
                            
                          ),
                    ),
                  );
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
            ],
          ),
        ),
      ),
    );
  }
}
