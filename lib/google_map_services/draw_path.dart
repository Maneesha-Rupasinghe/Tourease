import 'dart:async';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_service/location_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DrawPath extends StatefulWidget {
  final List<String> places;

  DrawPath({Key? key, required this.places}) : super(key: key);

  @override
  State<DrawPath> createState() => DrawPathState(places: places);
}

class DrawPathState extends State<DrawPath> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Set<Polyline> _polylines = Set<Polyline>();
  int _polylineIdCounter = 1;
  final List<String> places;
  DrawPathState({required this.places});

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.8731, 80.7718),
    zoom: 7.9,
  );

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < places.length - 1; i++) {
      _loadPlace(places[i], places[i + 1]);
    }
    _updateCameraPosition(places[0], places[places.length - 1]);
  }

  Future<void> _loadPlace(String input1, String input2) async {
    var directions = await LocationService().getDirections(input1, input2);

    _setPolyline(directions['polyline_decoded']);
    setState(() {}); // Force a rebuild
  }

  Future<void> _updateCameraPosition(String input1, String input2) async {
    var directions = await LocationService().getDirections(input1, input2);

    _goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );

    setState(() {}); // Force a rebuild
  }

  // static const Marker _kGooglePlexMarker = Marker(
  //   markerId: MarkerId('_kGooglePlex'),
  //   infoWindow: InfoWindow(title: 'Sri Lanka'),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position: LatLng(7.8731, 80.7718),
  // );
  // ignore: unused_element
  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 3,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Route'),
        backgroundColor: Colors.blueGrey.shade700,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            polylines: _polylines,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 12)),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          100),
    );
  }
}
