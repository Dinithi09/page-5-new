import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String activePage = "map"; // Track the active page

  // Economic centers with their coordinates
  final List<Map<String, dynamic>> economicCenters = [
    {"name": "Meegoda Economic Center", "lat": 6.8429, "lng": 80.0419},
    {"name": "Dambulla Economic Center", "lat": 7.8569, "lng": 80.6517},
    {"name": "Pettah Market", "lat": 6.9335, "lng": 79.8500},
  ];

  // Handle page change
  void handlePageChange(String page) {
    setState(() {
      activePage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sri Lanka Map Example'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Explore Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 100, horizontal: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/explore.jpg'), // Ensure the image is in assets
                    fit: BoxFit.cover,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'EXPLORE',
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Meegoda Economic Center',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'SRI LANKA',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        print("Explore Centers button pressed!");
                      },
                      child: Text('Explore Centers'),
                    ),
                  ],
                ),
              ),

              // Map Section
              Container(
                width: double.infinity,
                height: 500,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(7.8731, 80.7718), // Center of Sri Lanka
                    zoom: 8,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: economicCenters.map((center) {
                        return Marker(
                          point: LatLng(center['lat'], center['lng']),
                          builder: (ctx) => GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(center['name']),
                                    content: Text(
                                        "Latitude: ${center['lat']}, Longitude: ${center['lng']}"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Close"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.location_on,
                                color: Colors.red, size: 30),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Footer with BottomNavigationBar
              BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    activePage = index == 0
                        ? "home"
                        : index == 1
                        ? "chart"
                        : index == 2
                        ? "map"
                        : "contact";
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.show_chart),
                    label: "Chart",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: "Map",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone),
                    label: "Contact",
                  ),
                ],
                currentIndex: activePage == "home"
                    ? 0
                    : activePage == "chart"
                    ? 1
                    : activePage == "map"
                    ? 2
                    : 3,
                selectedItemColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
