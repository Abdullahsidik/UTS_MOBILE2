import 'package:flutter/material.dart';
import 'package:abdullahsidik_uts/database/databaseHelper.dart';
import 'dart:io';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<Map<String, dynamic>> allHotels = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.db;

    allHotels = await db?.query('hotels') ?? [];

    setState(() {}); // Trigger a rebuild after fetching data
  }

  Future<void> deleteHotel(int hotelId) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteHotel(hotelId);
    // Fetch data again after deletion
    await fetchData();
  }

  Future<List<Map<String, dynamic>>> getPromotionData() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.db;

    return await db?.query('hotels', where: 'rating < 5') ?? [];
  }

  Future<List<Map<String, dynamic>>> getTrendingData() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.db;

    return await db?.query('hotels', where: 'rating >= 5') ?? [];
  }

  Widget createListTile(
  String imagePath, 
  String title, 
  double rating, 
  int hotelId
) {
  return ListTile(
    leading: Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(
            // Assuming imagePath is a file path
            // Make sure to handle the case where the file does not exist
            File(imagePath),
          ),
        ),
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text('Rating: ${rating.toInt()}'),
      ],
    ),
    trailing: IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        await deleteHotel(hotelId);
      },
    ),
    onTap: () {
      // Handle item tap
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListPage'),
      ),
      body: Column(
        children: [
          DefaultTabController(
            length: 3, // Changed to 3 tabs (All Hotels, Promotion, Trending)
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Color.fromARGB(255, 236, 165, 33),
                    unselectedLabelColor: Color(0xFF555555),
                    labelColor: Color.fromARGB(255, 236, 165, 33),
                    labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    tabs: [
                      Tab(
                        text: "ALL DATA HOTEL",
                      ),
                      Tab(
                        text: "Rating tinggi",
                      ),
                      Tab(
                        text: "Rating rendah",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // All Hotels Tab content
                        ListView.builder(
                          itemCount: allHotels.length,
                          itemBuilder: (context, index) {
                            return createListTile(
                              allHotels[index]['imagePath'] ?? '',
                              allHotels[index]['nama'] ?? '',
                              allHotels[index]['rating'] ?? 0,
                              allHotels[index]
                                  ['id'], // Pass the hotelId to deleteHotel
                            );
                          },
                        ),

                        // Promotion Tab content
                        // Use a FutureBuilder to fetch and display promotion data
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: getTrendingData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              // Display promotion data
                              return ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return createListTile(
                                    snapshot.data![index]['imagePath'] ?? '',
                                    snapshot.data![index]['nama'] ?? '',
                                    snapshot.data![index]['rating'] ?? 0,
                                    snapshot.data![index][
                                        'id'], // Pass the hotelId to deleteHotel
                                  );
                                },
                              );
                            }
                          },
                        ),

                        // Trending Tab content
                        // Use a FutureBuilder to fetch and display trending data
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: getPromotionData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              // Display trending data
                              return ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return createListTile(
                                    snapshot.data![index]['imagePath'] ?? '',
                                    snapshot.data![index]['nama'] ?? '',
                                    snapshot.data![index]['rating'] ?? 0,
                                    snapshot.data![index][
                                        'id'], // Pass the hotelId to deleteHotel
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
