import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowQrCodeScreen extends StatefulWidget {
  final String appointmentId;
  const ShowQrCodeScreen({
    @required this.appointmentId,
  });
  @override
  _ShowQrCodeScreenState createState() => _ShowQrCodeScreenState();
}

class _ShowQrCodeScreenState extends State<ShowQrCodeScreen> {
  var imageUrl;

  bool isLoading = true;

  var _isInit = false;

  void getQrcode() async {
    //String appointmentId = widget.appointmentId;
    String appointmentId = '61292ccba64b18000460842a';
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/acceptedrequest/qrcode/$appointmentId');
    final response = await http.get(url);
    // final extractedData = json.decode(response.body)['data'];
    imageUrl = response.body;
    final index = imageUrl.indexOf(',');
    imageUrl = imageUrl.substring(index + 1, imageUrl.length);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQrcode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: MemoryImage(base64Decode(imageUrl)),
                  ),
                  Text(
                    'Scan Qr Code from that device',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
      ),
    );
  }
}
