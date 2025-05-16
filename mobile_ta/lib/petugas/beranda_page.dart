import 'package:flutter/material.dart';

class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("Total Sampah Terkumpul", style: TextStyle(fontSize: 16)),
          // SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0XFF8FD14F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Sampah terkumpul",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(height: 20),
                Text(
                  "Jenis Sampah",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Text(
                  "15.000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    height: 0.9,
                  ),
                ),
                Text(
                  "sampah botol",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w100,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
