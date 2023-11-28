import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AboutPage'),
        backgroundColor: Colors.amber,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto
          CircleAvatar(
            radius: 120.0,
            backgroundColor: Colors
                .amber, // Warna latar belakang, yang akan menjadi warna border
            child: CircleAvatar(
              radius:
                  115.0, // Mengurangkan sedikit dari radius utama untuk memberikan efek border
              backgroundImage: AssetImage('assets/images/bg1.jpg'),
            ),
          ),

          SizedBox(height: 16.0),

          // Nama, Kelas, dan NIM
          Text(
            'Nama: Abdulah Sidik\nKelas: TIF RP 221PB\nNIM: 21552011087',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),

          // Catatan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              'Aplikasi ini dibuat untuk menyimpan data hotel berupa gambar dan penjelasan. Diharapkan dapat dikembangkan lebih baik dari segi penyimpanan dan pemanggilan data.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
