import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_service/location_service.dart';

class ShowLocation extends StatefulWidget {
  final String city;
  final double zoom;

  ShowLocation({required this.city, required this.zoom});

  @override
  State<ShowLocation> createState() => ShowLocationState();
}

class ShowLocationState extends State<ShowLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    super.initState();

    LocationService().getPlace(widget.city).then((place) {
      _goToPlace(place);
    });
  }

  Future<void> _setMarker(LatLng point) async {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('marker'),
            position: point,
            icon: BitmapDescriptor.defaultMarker),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 50, // Adjust the height as needed
      child: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(7.8731, 80.7718),
          zoom: 7.9,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat =
        double.parse(place['geometry']['location']['lat'].toString());
    final double lng =
        double.parse(place['geometry']['location']['lng'].toString());

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: widget.zoom),
      ),
    );
    _setMarker(LatLng(lat, lng));
  }
}
