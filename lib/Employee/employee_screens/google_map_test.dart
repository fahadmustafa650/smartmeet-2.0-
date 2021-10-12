import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

const mapApiKey = 'AIzaSyAofr6MTAVjER_EanHr_GFsMGzOcehOeUU';

class EmployeeMapScreen extends StatefulWidget {
  const EmployeeMapScreen({Key key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _EmployeeMapScreenState createState() => _EmployeeMapScreenState();
}

class _EmployeeMapScreenState extends State<EmployeeMapScreen> {
  PickResult selectedPlace;
  // void showPlacePicker() async {
  //   LocationResult result = await Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => PlacePicker(
  //         "YOUR API KEY",
  //        // displayLocation: customLocation,
  //       ),
  //     ),
  //   );

  //   // Handle the result in your way
  //   print(result);
  // }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            // region: ,

                            onMapCreated: (result) {
                              print('result=$result');
                              // result.getLatLng(screenCoordinate);
                            },
                            apiKey: mapApiKey,
                            initialPosition: EmployeeMapScreen.kInitialPosition,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePlaceDetailSearch: true,
                            onPlacePicked: (result) {
                              selectedPlace = result;
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            //forceSearchOnZoomChanged: true,
                            //automaticallyImplyAppBarLeading: false,
                            //autocompleteLanguage: "ko",
                            //region: 'au',
                            //selectInitialPosition: true,
                            // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                            //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                            //   return isSearchBarFocused
                            //       ? Container()
                            //       : FloatingCard(
                            //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                            //           leftPosition: 0.0,
                            //           rightPosition: 0.0,
                            //           width: 500,
                            //           borderRadius: BorderRadius.circular(12.0),
                            //           child: state == SearchingState.Searching
                            //               ? Center(child: CircularProgressIndicator())
                            //               : RaisedButton(
                            //                   child: Text("Pick Here"),
                            //                   onPressed: () {
                            //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                            //                     //            this will override default 'Select here' Button.
                            //                     print("do something with [selectedPlace] data");
                            //                     Navigator.of(context).pop();
                            //                   },
                            //                 ),
                            //         );
                            // },
                            // pinBuilder: (context, state) {
                            // if (state == PinState.Idle) {
                            //   return Icon(Icons.favorite_border);
                            //   } else {
                            //     return Icon(Icons.favorite);
                            //   }
                            // },
                          );
                        },
                      ),
                    );
                  },
                ),
                selectedPlace == null
                    ? Container()
                    : Text(selectedPlace.formattedAddress ?? ""),
              ],
            ),
          )),
    );
  }
}
