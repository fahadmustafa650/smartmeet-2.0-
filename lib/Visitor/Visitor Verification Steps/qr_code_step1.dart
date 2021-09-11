import 'package:flutter/material.dart';
import 'package:smart_meet/widgets/custom_stepper.dart';
import 'package:http/http.dart' as http;
import 'facial_recognition_step2.dart';
import 'temperature_detector_step3.dart';

class ScanQRCodeStep1 extends StatefulWidget {
  static final id = '/scan_qrcode_step1';

  @override
  _ScanQRCodeStep1State createState() => _ScanQRCodeStep1State();
}

class _ScanQRCodeStep1State extends State<ScanQRCodeStep1> {
  var imageUrl;
  bool isLoading = true;
  var _isInit = false;
  void getQrcode() async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/acceptedrequest/qrcode/61292ccba64b18000460842a');
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
    super.initState();
    _isInit = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      getQrcode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('QR Code Vertification Step'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.forward, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, FacialRecognitionStep2.id);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            CustomStepper(
              stepNo: 1,
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Text(
                'Scan QR Code from your Device',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            isLoading
                ? CircularProgressIndicator()
                : Image(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.4,
                    image: MemoryImage(imageUrl),
                  ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
