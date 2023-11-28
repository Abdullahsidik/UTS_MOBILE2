import 'dart:io';
import 'package:flutter/material.dart';
import 'package:abdullahsidik_uts/database/databaseHelper.dart';

class SearchHotel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Hotel'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 20.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Color(0x55434343),
              child: TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              // Load hotel data from the database
              future: DatabaseHelper().getAllHotels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hotels found.'));
                } else {
                  return Container(
                    padding: EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 29.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Extracting data from the database
                        var hotelData = snapshot.data![index];
                        String imgUrl = hotelData['imagePath'];
                        String hotelName = hotelData['nama'];
                        int rating = hotelData['rating'].toInt();
                        String harga = hotelData['harga'].toString();

                        // Building the grid card
                        return gridCard(imgUrl, hotelName, harga, rating);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
Widget gridCard(String imgUrl, String hotelName, String location, int rating) {
  return Card(
    margin: EdgeInsets.only(right: 1.0),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    elevation: 0.0,
    child: InkWell(
      onTap: () {},
      child: Container(
        width: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: Colors.amber, // Set the border color to amber
            width: 2.0, // Set the border width
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.0),
          child: Column(
            children: [
              imgUrl.startsWith('http')
                  ? Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250.0,
                      alignment: Alignment.center,
                    )
                  : Image.file(
                      File(imgUrl),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250.0,
                      alignment: Alignment.center,
                    ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < rating; i++)
                          Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 236, 165, 33),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      'Hotel $hotelName',
                      style: TextStyle(
                        color: Color.fromARGB(255, 24, 24, 24),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      'Rp. $location.00',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 90, 90),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
