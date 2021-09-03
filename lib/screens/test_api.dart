import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_meet/models/appointment.dart';
import 'package:smart_meet/providers/appointments_provider.dart';

class GetImage extends StatefulWidget {
  const GetImage({Key key}) : super(key: key);

  @override
  _GetImageState createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  final url = Uri.parse(
      'https://pure-woodland-42301.herokuapp.com/api/visitor/fahsdfssssvvssdsddddddjssssjhdgjddksssddslfjs11@gmail.com/avatar');
  var extractedData;
  var isLoading = true;
  void getData() async {
    final response = await http.get(url);
    extractedData = await json.decode(response.body);

    if (extractedData == null) {
      return;
    }
    setState(() {
      isLoading = false;
    });
    print(extractedData);
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final appointment =
        Provider.of<PendingAppointmentsRequestsProvider>(context);
    return Center(
        child: TextButton(
      onPressed: () {
        appointment.pendingAppointmentRequestsList('612c967d21b51e000445207d');
      },
      child: Text('Get Data'),
    ));
  }
}
