import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImageOcrTest extends StatefulWidget {
  @override
  _ImageOcrTestState createState() => _ImageOcrTestState();
}

class _ImageOcrTestState extends State<ImageOcrTest> {
  File _image;
  final picker = ImagePicker();
  String resultX;
  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  bool isloaded = false;
  var result;
  // fetch() async {
  //   var response = await http.get(Uri.parse(
  //       'https://pure-woodland-42301.herokuapp.com/api/visitor/signup'));
  //   result = jsonDecode(response.body);
  //   print(result[0]['image']);
  //   setState(() {
  //     isloaded = true;
  //   });
  // }

  void performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(_image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);
    resultX = '';
    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String text = block.text;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            resultX += element.text + " ";
          }
        }
        resultX += "\n\n";
      }
      print(resultX);
    });
  }

  @override
  Widget build(BuildContext context) {
    //fetch();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text("Select an image"),
          _image == null ? Text('no image found') : Image.file(_image),
          FlatButton.icon(
            onPressed: () async => await getImage(),
            icon: Icon(Icons.upload_file),
            label: Text("Image"),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton.icon(
            onPressed: () async => await performImageLabeling(),
            icon: Icon(Icons.upload_file),
            label: Text("Get Text"),
          ),
          Text(resultX == null ? '' : resultX)
        ],
      ),
    );
  }
}
