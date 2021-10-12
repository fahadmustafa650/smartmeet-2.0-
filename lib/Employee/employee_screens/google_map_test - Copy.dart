import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

const mapApiKey = 'AIzaSyAofr6MTAVjER_EanHr_GFsMGzOcehOeUU';

class EmployeeMapScreen2 extends StatefulWidget {
  const EmployeeMapScreen2({Key key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _EmployeeMapScreen2State createState() => _EmployeeMapScreen2State();
}

class _EmployeeMapScreen2State extends State<EmployeeMapScreen2> {
  
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              mapApiKey,
              displayLocation: null,
            )));
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Google Map Place Picer"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Load Google Map"),
                  onPressed: () {
                    showPlacePicker();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return;
                    //     },
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          )),
    );
  }
}
