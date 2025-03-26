import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapProvider extends ChangeNotifier {
  LatLng? _userLocation;

  LatLng? get userLocation => _userLocation;

  LatLng _orderLocation = LatLng(23.722740, 90.413933);

  LatLng get orderLocation => _orderLocation;

  final String _apiKey = 'AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY';
  final Set<Polyline> _polylines = {};

  Set<Polyline> get polylines => _polylines;

  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  StreamSubscription<Position>? _positionStream;
  Set<Marker> markerList = {};
  List<LatLng> _polylineCoordinates = [];
  bool _routeNotFound = false; // Flag to control error message display

  bool get routeNotFound => _routeNotFound;

  String distance = '0.0 km';
  String duration = '0.0 mins';

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  Future<void> initializeLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog(context);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog(context);
      return Future.error('Location permissions are permanently denied.');
    }

    // Delay for 5 seconds before fetching location

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 4, // Update every 4 meters
      ),
    ).listen((Position position) async {
      _userLocation = LatLng(position.latitude, position.longitude);
      debugPrint(
          'User current Location : ${_userLocation!.latitude}, ${_userLocation!.longitude}');

      // Update user location marker dynamically
      markerList.removeWhere((m) => m.markerId.value == 'userLocation');
      markerList.add(Marker(
        markerId: MarkerId('userLocation'),
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/png/location_pin.png', 60),
        ),
        position: _userLocation!,
        infoWindow: InfoWindow(title: 'Your Location'),
      ));

      _updatePolyline();
      fetchDistanceAndDuration(
          _userLocation!, orderLocation); // Update distance/duration
      notifyListeners();
    });
  }

  Future<void> setOrderLocation(LatLng location, String address) async {
    _orderLocation = location;
    debugPrint('setOrderLocation ${location.toString()}');
    await _updatePolyline();
    notifyListeners();
  }

  Future<void> _updatePolyline() async {
    if (_userLocation == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=${_orderLocation.latitude},${_orderLocation.longitude}&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isEmpty) return;

      final points =
          _decodePolyline(data['routes'][0]['overview_polyline']['points']);
      _polylineCoordinates = points;
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: points,
          color: Colors.black,
          width: 6,
        ),
      );

      // Clear previous markers
      markerList.clear();

      // Add marker for user's current location
      // markerList.add(
      //   Marker(
      //     markerId: MarkerId('userLocation'),
      //     icon: BitmapDescriptor.fromBytes(
      //       await getBytesFromAsset('assets/png/location_pin.png', 100),
      //     ),
      //     position: _userLocation!,
      //     infoWindow: InfoWindow(title: 'Your Location'),
      //   ),
      // );

      // Add marker for order location
      if (points.isNotEmpty) {
        LatLng finalDestination = points.last; // Last point of the polyline
        Uint8List adjustPinIcon =
            await getBytesFromAsset('assets/png/adjustPin.png', 100);
        // Get place name and image URL
        String placeName = await _getPlaceName(finalDestination);

        markerList.add(
          Marker(
            markerId: MarkerId('orderLocation'),
            icon: BitmapDescriptor.fromBytes(adjustPinIcon),
            position: finalDestination,
            infoWindow: InfoWindow(title: 'Order Location', snippet: placeName),
          ),
        );
      }
      // _fitMapToPolyline(); // Zooms out to fit the full route

      notifyListeners();
    } else {
      throw Exception('Failed to fetch polyline');
    }
  }

  void _fitMapToPolyline() {
    if (_mapController == null || _polylineCoordinates.isEmpty) return;

    LatLngBounds bounds = _getBoundsFromPolyline(_polylineCoordinates);

    _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80)); // Adjust padding
  }

  LatLngBounds _getBoundsFromPolyline(List<LatLng> polyline) {
    double minLat = polyline.first.latitude;
    double maxLat = polyline.first.latitude;
    double minLng = polyline.first.longitude;
    double maxLng = polyline.first.longitude;

    for (LatLng point in polyline) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    List<int> bytes = encoded.codeUnits;
    int index = 0, lat = 0, lng = 0;

    while (index < bytes.length) {
      int shift = 0, result = 0;
      int byte;
      do {
        byte = bytes[index++] - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        byte = bytes[index++] - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }

  Future<void> fetchDistanceAndDuration(
      LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final route = data['routes'][0];
        final leg = route['legs'][0];
        distance = leg['distance']['text'];
        duration = leg['duration']['text'];
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content:
            Text('Please enable location permissions in the app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // Call this method to start navigation
  Future<void> startNavigation() async {
    if (userLocation == null) {
      print("User location or destination is not set!");
      return;
    }
    final Uri googleMapsUrl = Uri.parse(
        'google.navigation:q=${orderLocation.latitude},${orderLocation.longitude}&mode=d'); // 'd' = driving mode
    print("Navigation URL: $googleMapsUrl");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch Google Maps for navigation");
      throw 'Could not launch Google Maps';
    }
  }

  Future<String> _getPlaceName(LatLng position) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]
            ['formatted_address']; // Return the formatted address
      } else {
        return 'Unknown Place';
      }
    } else {
      throw Exception('Failed to fetch place name');
    }
  }

  void _animateCameraToLocation(LatLng targetLocation) {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: targetLocation,
          zoom: 2.0, // Adjust zoom level as needed
          tilt: 45.0, // Optional: Adds a tilt for a 3D effect
          bearing: 90.0, // Optional: Rotates the camera
        ),
      ),
    );
  }

  void zoomInAndOutToUserAndOrder() {
    bool toggle = true;

    Timer.periodic(Duration(seconds: 30), (timer) async {
      LatLng targetLocation = toggle ? _userLocation! : _orderLocation;
      toggle = !toggle;
      await mapController!.animateCamera(CameraUpdate.zoomOut());
      await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: targetLocation,
            zoom: 2.0, // Adjust zoom level as needed
            tilt: 45.0, // Optional for 3D effect
            bearing: 0.0, // Keep north aligned
          ),
        ),
      );
      await mapController!.animateCamera(CameraUpdate.zoomIn());
    });
  }

  // Method to check if LatLng is valid (in your case, check order LatLng)
  void validateLocation(LatLng? orderLatLng) {
    if (orderLatLng == null) {
      _routeNotFound = true;
    } else {
      _routeNotFound = false;
    }
    notifyListeners();
  }
}
