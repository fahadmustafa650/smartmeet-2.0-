import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_meet/providers/employee_office_location_provider.dart';
import 'package:smart_meet/providers/employee_provider.dart';
import 'package:smart_meet/Constants/constants.dart';
// const mapApiKey = 'AIzaSyAofr6MTAVjER_EanHr_GFsMGzOcehOeUU';

class GoogleMapSearchScreen extends StatefulWidget {
  final String employeeId;
  GoogleMapSearchScreen({this.employeeId});
  @override
  State<GoogleMapSearchScreen> createState() => GoogleMapSearchScreenState();
}

class GoogleMapSearchScreenState extends State<GoogleMapSearchScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final _searchController = TextEditingController();
  Marker _employeeOfficeMarker;
  // static final Marker _kGooglePlexMarker = Marker(
  //   markerId: MarkerId('_kGooglePlex'),
  //   infoWindow: InfoWindow(title: 'Google Plex'),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position: LatLng(37.43296265331129, -122.08832357078792),
  // );
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // static final CameraPosition _kLake = CameraPosition(
  //   bearing: 192.8334901395799,
  //   target: LatLng(37.43296265331129, -122.08832357078792),
  //   tilt: 59.440717697143555,
  //   zoom: 19.151926040649414,
  // );
  Future<String> getPlaceId(String input) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$mapApiKey');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    //print(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    //print('placeId=$placeId');
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapApiKey');
    var response = await http.get(url);
    print('code=${response.statusCode}');
    var json = jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    print('body=${response.body}');
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final employeeLocationData =
        Provider.of<EmployeeOfficeLocationProvider>(context, listen: true);
    final employeeData = Provider.of<EmployeesProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Place',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    final place = await getPlace(_searchController.text);
                    _goToPlace(place);
                  },
                )
              ],
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                markers: {
                  //if (_origin != null) _origin,
                  if (_employeeOfficeMarker != null) _employeeOfficeMarker,
                },
                onTap: _addMarker,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 15),
          width: 200,
          child: FloatingActionButton.extended(
            onPressed: () {
              //LatLng l = LatLng(34.4345345, 23.423423);
              employeeLocationData.saveLocation(
                employeeData.getEmployee.id,
                _employeeOfficeMarker.position,
              );
            },
            label: Text(
              'Save',
              style: TextStyle(fontSize: 20),
            ),
            //icon: Icon(Icons.directions_boat),
          ),
        ),
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 18)));
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  // void saveLocation() {
  //   final url = Uri.parse(
  //       'https://pure-woodland-42301.herokuapp.com/api/employee_location');
  // }

  void _addMarker(LatLng pos) async {
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
    // } else {
    // Origin is already set
    // Set destination
    setState(() {
      _employeeOfficeMarker = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: pos,
      );
    });
    print('lat=${_employeeOfficeMarker.position.latitude}');
    print('long=${_employeeOfficeMarker.position.longitude}');
    //print(_employeeOfficeMarker.);
    // Get directions
    // final directions = await DirectionsRepository().getDirections(
    //     origin: LatLng(currentPosition.latitude, currentPosition.longitude),
    //     destination: pos);
    // print('directions=$directions');
    // setState(() => _info = directions);
    //}
  }
}
