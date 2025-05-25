import 'package:flutter/material.dart';
import 'package:mobile_ta/petugas/petugas_setor_page.dart';
import '../petugas/beranda_page.dart';

class PetugasMainWrapper extends StatefulWidget {
  const PetugasMainWrapper({Key? key}) : super(key: key);

  @override
  State<PetugasMainWrapper> createState() => _WargaMainWrapperState();
}

class _WargaMainWrapperState extends State<PetugasMainWrapper> {
  int selectedMenu = 0;

  List menu = [PetugasBerandaPage(), PetugasSetorPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: menu[selectedMenu],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedMenu,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.grey.shade200,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedMenu = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'Setor'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Edukasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
