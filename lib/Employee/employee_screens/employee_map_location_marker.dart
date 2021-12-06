import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_meet/Constants/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:smart_meet/models/direction_repository.dart';
import 'package:smart_meet/models/directions.dart';
//import 'package:geocoder/geocoder.dart';

const mapApiKey = 'AIzaSyAofr6MTAVjER_EanHr_GFsMGzOcehOeUU';

class EmployeeMapLocationMarker extends StatefulWidget {
  @override
  _EmployeeMapLocationMarkerState createState() =>
      _EmployeeMapLocationMarkerState();
}

class _EmployeeMapLocationMarkerState extends State<EmployeeMapLocationMarker> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  GoogleMapController _googleMapController;
  //Marker _origin;
  Marker _officeLocation;
  Directions _info;
  Position currentPosition;
  var geolocator = Geolocator();
  var _isLoading = true;
  Future<void> locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((value) {
      currentPosition = value;
      print('currentPosition:== $currentPosition');
      if (currentPosition != null) {
        print(currentPosition.latitude);
        print(currentPosition.longitude);
        LatLng a = LatLng(33.738045, 73.084488);
        _addMarker(a);
        LatLng latLng =
            LatLng(currentPosition.latitude, currentPosition.longitude);
        setState(() {
          _isLoading = false;
        });
        CameraPosition cameraPosition = CameraPosition(
          target: latLng,
          zoom: 14.4746,
        );

        _googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      }

      return;
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locatePosition();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text('Choose Office Location'),
        actions: [
          if (_officeLocation != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _officeLocation.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Save',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  )),
            )
        ],
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Stack(
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
                    if (_officeLocation != null) _officeLocation,
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
                  //onLongPress: _addMarker,
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

  void _addMarker(LatLng pos) async {
    setState(() {
      _officeLocation = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
    });

    // Get directions
    final directions = await DirectionsRepository().getDirections(
        origin: LatLng(currentPosition.latitude, currentPosition.longitude),
        destination: pos);
    print('directions=$directions');
    setState(() => _info = directions);
    //}
  }
}
