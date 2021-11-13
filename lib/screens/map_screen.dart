import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:smart_meet/models/direction_repository.dart';
import 'package:smart_meet/models/directions.dart';
import 'package:smart_meet/providers/employee_office_location_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  GoogleMapController _googleMapController;
  //Marker _origin;
  Marker _destination;
  Directions _info;
  Position currentPosition;
  var geolocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 14.4746,
    );
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  var _isInit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var _isInit = true;
    locatePosition();
  }

  @override
  void dispose() {
    if (_isInit) {
      Provider.of<EmployeeOfficeLocationProvider>(context);
      //_setDestination();
    }

    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          // if (_origin != null)
          //   TextButton(
          //     onPressed: () => _googleMapController.animateCamera(
          //       CameraUpdate.newCameraPosition(
          //         CameraPosition(
          //           target: _origin.position,
          //           zoom: 14.5,
          //           tilt: 50.0,
          //         ),
          //       ),
          //     ),
          //     style: TextButton.styleFrom(
          //       primary: Colors.green,
          //       textStyle: const TextStyle(fontWeight: FontWeight.w600),
          //     ),
          //     child: const Text(
          //       'ORIGIN',
          //       style: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // if (_destination != null)
          //   TextButton(
          //     onPressed: () => _googleMapController.animateCamera(
          //       CameraUpdate.newCameraPosition(
          //         CameraPosition(
          //           target: _destination.position,
          //           zoom: 14.5,
          //           tilt: 50.0,
          //         ),
          //       ),
          //     ),
          //     style: TextButton.styleFrom(
          //       primary: Colors.blue,
          //       textStyle: const TextStyle(fontWeight: FontWeight.w600),
          //     ),
          //     child: const Text('DEST',
          //         style: const TextStyle(
          //           color: Colors.white,
          //         )),
          //   )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            padding: EdgeInsets.only(bottom: 265.0),
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              //_googleMapController = controller;
              locatePosition();
            },
            markers: {
              //if (_origin != null) _origin,
              if (_destination != null) _destination,
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            // onLongPress: _setDestination,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    const BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info.totalDistance}, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _setDestination(LatLng pos) async {
    // if (_origin == null || (_origin != null && _destination != null)) {
    //   // Origin is not set OR Origin/Destination are both set
    //   // Set origin
    //   setState(() {
    //     _origin = Marker(
    //       markerId: const MarkerId('origin'),
    //       infoWindow: const InfoWindow(title: 'Origin'),
    //       icon:
    //           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //       position: pos,
    //     );
    //     // Reset destination
    //     _destination = null;

    //     // Reset info
    //     _info = null;
    //   });
    // }
    //else {
    // Origin is already set
    // Set destination
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
    });

    // Get directions
    final directions = await DirectionsRepository().getDirections(
      origin: LatLng(currentPosition.latitude, currentPosition.longitude),
      destination: pos,
    );

    setState(() => _info = directions);
    //}
  }
}
