import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/providers/employee_pending_appointments_provider.dart';

class GetImage extends StatefulWidget {
  const GetImage({Key key}) : super(key: key);

  @override
  _GetImageState createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  String imageUrl;
  var isLoading = true;
  void getData() async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/acceptedrequest/qrcode/61292ccba64b18000460842a');
    final response = await http.get(url);
    // final extractedData = json.decode(response.body)['data'];
    imageUrl = response.body;
    final a = imageUrl.indexOf(',');
    imageUrl = imageUrl.substring(a + 1, imageUrl.length);

    setState(() {
      isLoading = false;
    });
    // print(extractedData);
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: getData,
            child: Text('Get Data'),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Image(
                  image: MemoryImage(base64Decode(imageUrl)),
                )
        ],
      ),
    ));
  }
}
