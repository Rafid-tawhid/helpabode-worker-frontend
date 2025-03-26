// import 'package:flutter/material.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class NavigationMapScreen extends StatefulWidget {
//   @override
//   _NavigationMapScreenState createState() => _NavigationMapScreenState();
// }
//
// class _NavigationMapScreenState extends State<NavigationMapScreen> {
//   MapboxMap? mapboxMap;
//
//   final String _mapboxAccessToken = "pk.eyJ1IjoicmFmaWR0YXdoaWQiLCJhIjoiY203enBmc3IyMG5veTJscTRzcGNrdTR2dSJ9.waHUb04g9eDS_GybsRv7Dw";
//
//   // Example Origin & Destination (Dhaka)
//   final List<double> _origin = [90.4125, 23.8103]; // Dhaka
//   final List<double> _destination = [90.4255, 23.8151]; // Nearby Place
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   // Fetch Route from Mapbox API
//   Future<List<List<double>>> _fetchRoute() async {
//     final String url =
//         "https://api.mapbox.com/directions/v5/mapbox/driving/${_origin[0]},${_origin[1]};${_destination[0]},${_destination[1]}?geometries=geojson&access_token=$_mapboxAccessToken";
//
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         var route = data['routes'][0]['geometry']['coordinates'];
//         return List<List<double>>.from(route);
//       } else {
//         print("Failed to load route: ${response.statusCode}");
//         return [];
//       }
//     } catch (e) {
//       print("Error fetching route: $e");
//       return [];
//     }
//   }
//
//   // Draw Route on Map
//   void _drawRoute(List<List<double>> coordinates) {
//     if (mapboxMap == null) return;
//
//     List<Position> routePositions = coordinates.map((coord) {
//       return Position(coord[0], coord[1]);
//     }).toList();
//
//     mapboxMap!.annotations.createPolygonAnnotationManager(
//
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Mapbox Navigation")),
//       body: MapWidget(
//         mapOptions: MapOptions(pixelRatio: 1.2),
//         styleUri: MapboxStyles.MAPBOX_STREETS,
//         onMapCreated: (MapboxMap map) async {
//           mapboxMap = map;
//
//           // Fetch and Draw Route
//           List<List<double>> routeCoordinates = await _fetchRoute();
//           if (routeCoordinates.isNotEmpty) {
//             _drawRoute(routeCoordinates);
//           }
//         },
//       ),
//     );
//   }
// }
