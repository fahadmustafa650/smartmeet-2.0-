import 'package:flutter/material.dart';
import 'package:smart_meet/Visitor/Appointment/search_result_screen.dart';

class EmployeeSearchBar extends StatefulWidget {
  static final id = '/employee_search_bar';
  EmployeeSearchBar({Key key}) : super(key: key);

  @override
  _EmployeeSearchBarState createState() => new _EmployeeSearchBarState();
}

class _EmployeeSearchBarState extends State<EmployeeSearchBar> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Employee'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search Employee",
                    hintText: "Search Employee",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, EmployeeSearchResultScreen(name: searchController.text.toString()));
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return EmployeeSearchResultScreen(
                    name: searchController.text.toString(),
                  );
                }));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue),
                child: Center(
                  child: Text(
                    'Search your Employee',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
