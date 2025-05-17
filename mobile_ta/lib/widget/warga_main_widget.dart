import 'package:flutter/material.dart';
import 'package:mobile_ta/warga/akun_page.dart';
import 'package:mobile_ta/warga/edukasi_page.dart';
import 'package:mobile_ta/warga/setor_page.dart';
import '../warga/beranda_page.dart';

class WargaMainWrapper extends StatefulWidget {
  const WargaMainWrapper({Key? key}) : super(key: key);

  @override
  State<WargaMainWrapper> createState() => _WargaMainWrapperState();
}

class _WargaMainWrapperState extends State<WargaMainWrapper> {
  int selectedMenu = 0;

  List menu = [WargaBerandaPage(), WargaSetorPage(), WargaEdukasiPage(), WargaAkunPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: menu.elementAtOrNull(selectedMenu),
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
