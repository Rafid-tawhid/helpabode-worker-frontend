import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_abode_worker_app_ver_2/provider/map_provider.dart';
import 'package:provider/provider.dart';

class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Location'),
      ),
      body: Consumer<MapProvider>(
          builder: (context, mapProvider, _) => Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) {
                      mapProvider.setMapController(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: mapProvider.userLocation!,
                      zoom: 12.0,
                    ),
                    markers: mapProvider.markerList,
                    polylines: mapProvider.polylines,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Distance :${mapProvider.distance}'),
                            Text('Duration :${mapProvider.duration}'),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
    );
  }
}
