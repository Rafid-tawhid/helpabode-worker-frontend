import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdjustPinScreen extends StatefulWidget {
  const AdjustPinScreen({
    super.key,
    this.text,
    required this.lat,
    required this.lon,
  });

  final String? text;
  final double lat;
  final double lon;

  @override
  _AdjustPinScreenState createState() => _AdjustPinScreenState();
}

class _AdjustPinScreenState extends State<AdjustPinScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng markerPosition = LatLng(0, 0);
  Set<Marker> _markers = Set();
  // ignore: unused_field
  CameraPosition? _initialPosition;

  @override
  void initState() {
    _getLocation();
    print('latitude :${widget.lat}');
    print('logtitude :${widget.lon}');
    super.initState();
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

  Future<void> _getLocation() async {
    setState(() {
      markerPosition = LatLng(widget.lat, widget.lon);
    });
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/png/adjustPin.png', 150);
    try {
      final String markerIdVal = UniqueKey().toString();
      final MarkerId markerId = MarkerId(markerIdVal);

      _markers.clear();
      _markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: markerId,
          position: markerPosition,
          infoWindow: InfoWindow(
            title: 'Pinned Address',
          ),
        ),
      );
      _initialPosition = CameraPosition(
        target: markerPosition,
        zoom: 12,
      );

      setState(() {});
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _updateCameraPosition(CameraPosition position) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/png/adjustPin.png', 150);
    final String markerIdVal = UniqueKey().toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    setState(() {
      markerPosition =
          LatLng(position.target.latitude, position.target.longitude);

      _markers.clear();
      _markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: markerId,
          position: markerPosition,
          infoWindow: InfoWindow(
            title: 'Pinned Address',
          ),
        ),
      );
    });
  }

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      // appBar: AppBar(
      //   leading: SizedBox(),
      //   backgroundColor: Colors.white,
      //   elevation: 1,
      //   flexibleSpace: SafeArea(
      //     child: Column(
      //       children: [
      //         Center(
      //           child: Container(
      //             height: 4,
      //             width: 44,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(4),
      //               color: Color(0xFFD9D9D9),
      //             ),
      //           ),
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             SizedBox(
      //               height: 40,
      //               child: IconButton(
      //                 splashRadius: 30,
      //                 onPressed: () {
      //                   Navigator.pop(context);
      //                 },
      //                 icon: Icon(Icons.close),
      //               ),
      //             ),
      //             Expanded(
      //               child: Center(
      //                 child: Text(
      //                   'Adjust Pin',
      //                   style: TextStyle(fontSize: 18),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(width: 50),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: GoogleMap(
        compassEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        onCameraMove: (CameraPosition newPosition) {
          // _updateCameraPosition(newPosition);
        },
        initialCameraPosition: CameraPosition(
          zoom: 12,
          target: markerPosition,
        ),
        zoomControlsEnabled: false,
        markers: _markers,
      ),
    );
  }
}
