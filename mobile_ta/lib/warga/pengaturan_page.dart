import 'package:flutter/material.dart';

class WargaPengaturanPage extends StatefulWidget {
  const WargaPengaturanPage({super.key});

  @override
  State<WargaPengaturanPage> createState() => _WargaPengaturanPageState();
}

class _WargaPengaturanPageState extends State<WargaPengaturanPage> {
  bool _darkMode = false;
  bool _notifEnabled = true;
  String _selectedLanguage = 'Indonesia';

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
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Mode Gelap"),
            subtitle: const Text("Ubah ke tampilan dark mode"),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              // Diimplementasi nyata, ganti theme global di sini
            },
          ),
          SwitchListTile(
            title: const Text("Notifikasi"),
            subtitle: const Text("Aktifkan atau nonaktifkan notifikasi"),
            value: _notifEnabled,
            onChanged: (value) {
              setState(() {
                _notifEnabled = value;
              });
              // Simpan status notifikasi ke local storage atau server
            },
          ),
          ListTile(
            title: const Text("Bahasa"),
            subtitle: Text(_selectedLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: ['Indonesia', 'English']
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  // Ganti locale / simpan ke preferences
                }
              },
            ),
          ),
          ListTile(
            title: const Text("Tentang Aplikasi"),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Bank Sampah Warga",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2025 - Projek TA",
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Aplikasi ini membantu warga dalam mengelola sampah dan pengajuan setor secara digital.",
                    ),
                  )
                ],
              );
            },
          ),
          const ListTile(
            title: Text("Versi Aplikasi"),
            subtitle: Text("1.0.0"),
          ),
        ],
      ),
    );
  }
}
