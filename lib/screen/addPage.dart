import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:abdullahsidik_uts/database/databaseHelper.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController namaHotelController = TextEditingController();
  TextEditingController hargaHotelController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController tentangHotelController = TextEditingController();
  File? _image; // To store the selected image

  // Function to pick an image from the gallery or camera
  Future _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _saveData() async {
    if (_image == null) {
      // Show a warning if the image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih foto terlebih dahulu!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (double.parse(ratingController.text) > 6.0) {
      // Show a warning if rating is greater than 6
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating tidak boleh lebih dari 6!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final database = await DatabaseHelper().db;
    if (database != null) {
      await DatabaseHelper().insertHotel({
        'nama': namaHotelController.text,
        'harga': int.parse(hargaHotelController.text),
        'rating': double.parse(ratingController.text),
        'tentang': tentangHotelController.text,
        'imagePath': _image?.path ?? '',
      });

      // Show success notification using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data saved successfully!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Hotel')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Displaying the image avatar
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 24),
                height: 175.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Material(
                    elevation: 10.0,
                    shadowColor: Color(0x55434343),
                    child: InkWell(
                      onTap: () async {
                        await _pickImage();
                        setState(() {});
                      },
                      child: Center(
                        child: _image != null
                            ? Image.file(_image!,
                                fit: BoxFit.cover, width: double.infinity)
                            : Icon(Icons.camera_alt,
                                size: 70.0, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.0),

              // Nama Hotel TextField
              Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0x55434343),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: namaHotelController,
                    decoration: InputDecoration(
                      labelText: 'Nama Hotel',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Harga Hotel TextField
              Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0x55434343),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: hargaHotelController,
                    decoration: InputDecoration(
                      labelText: 'Harga',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Rating TextField
              Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0x55434343),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: ratingController,
                    decoration: InputDecoration(
                      labelText: 'Rating 1/6',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Tentang Hotel TextField
              Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Color(0x55434343),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: tentangHotelController,
                    decoration: InputDecoration(
                      labelText: 'Tentang Hotel',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await _saveData();
                      debugPrint("Data saved successfully!");
                      // Navigator.of(context).pop();
                    } catch (e) {
                      print("Error saving data: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
