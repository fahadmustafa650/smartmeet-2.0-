import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_meet/models/visitor_model.dart';
import 'package:http/http.dart' as http;

class VisitorProvider with ChangeNotifier {
  Visitor _visitor;

  Visitor get getVisitor {
    return _visitor == null ? Visitor() : _visitor;
  }

  void destroyVisitor() {
    _visitor = Visitor(
      id: null,
      firstName: null,
      lastName: null,
      username: null,
      email: null,
      dateOfBirth: null,
      imageUrl: null,
    );
  }

  Future<void> getVisitorDataByEmail(String email) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/$email/viewProfile');
    final response = await http.get(url);
    final visitorData = jsonDecode(response.body);
    // final List<int> imageData =
    //     await (visitorData['user']['avatar']['data']).cast<int>();
    // Uint8List imageList = Uint8List.fromList(imageData);
    // this.imageList = imageList;
    _visitor = Visitor(
      id: visitorData['user']['_id'].toString(),
      firstName: visitorData['user']['firstName'].toString(),
      lastName: visitorData['user']['lastName'].toString(),
      username: visitorData['user']['username'].toString(),
      email: email,
      dateOfBirth: DateTime.tryParse(visitorData['user']['dateOfBirth']),
      imageUrl: visitorData['user']['avatar'].toString(),
    );
    notifyListeners();
  }

  Future<void> getVisitorDataById(String id) async {
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/usersProfile/$id');
    final response = await http.get(url);
    final visitorData = jsonDecode(response.body);
    print(visitorData);
    _visitor = Visitor(
      id: visitorData['user']['id'].toString(),
      firstName: visitorData['user']['firstName'].toString(),
      lastName: visitorData['user']['lastName'].toString(),
      username: visitorData['user']['username'].toString(),
      email: id,
      dateOfBirth: DateTime.tryParse(visitorData['user']['dateOfBirth']),
      imageUrl: visitorData['user']['avatar'].toString(),
    );
    notifyListeners();
  }

  Future<int> updateVisitorData(Visitor visitorData) async {
    final prevVisitorData = getVisitor;
    final url = Uri.parse(
        'https://pure-woodland-42301.herokuapp.com/api/visitor/updateProfile');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'id': visitorData.id,
        'firstName': visitorData.firstName != null
            ? visitorData.firstName
            : prevVisitorData.firstName,
        'lastName': visitorData.lastName != null
            ? visitorData.lastName
            : prevVisitorData.lastName,
        'avatar': visitorData.imageUrl != null
            ? visitorData.imageUrl
            : prevVisitorData.imageUrl,
      }),
    );
    if (response.statusCode == 200) {
      print('Data Updated');
      _visitor = Visitor(
        id: prevVisitorData.id,
        firstName: visitorData.firstName != null
            ? visitorData.firstName
            : prevVisitorData.firstName,
        lastName: visitorData.lastName != null
            ? visitorData.lastName
            : prevVisitorData.lastName,
        username: prevVisitorData.username,
        email: prevVisitorData.email,
        dateOfBirth: prevVisitorData.dateOfBirth,
        imageUrl: visitorData.imageUrl != null
            ? visitorData.imageUrl
            : prevVisitorData.imageUrl,
      );

      notifyListeners();
      return response.statusCode;
    } else {
      print('error occured in updating');
      notifyListeners();
      return response.statusCode;
    }
  }
}
