import 'dart:typed_data';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_meet/Constants/constants.dart';

class OtpScreen extends StatefulWidget {
  static final id = '/otp_screen';

  final String email;
  final Function addAllData;
  // final Visitor visitor;
  // const OtpScreen({@required this.visitor});
  const OtpScreen({@required this.email, @required this.addAllData});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int timeValue = 30;
  String otpCode = '';
  var beginTime = 90.0;
  var endTime = 0.0;
  //FOCUS NODES
  FocusNode pin1FocusNode;
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;
  //CircleAvatars background Color
  Color circlePinColor1 = Colors.white;
  Color circlePinColor2 = Colors.white;
  Color circlePinColor3 = Colors.white;
  Color circlePinColor4 = Colors.white;
  Color circlePinColor5 = Colors.white;
  Color circlePinColor6 = Colors.white;
  //Controllers Digit
  final circlePin1Controller = TextEditingController();
  final circlePin2Controller = TextEditingController();
  final circlePin3Controller = TextEditingController();
  final circlePin4Controller = TextEditingController();
  final circlePin5Controller = TextEditingController();
  final circlePin6Controller = TextEditingController();
  //Loading
  bool _isLoading = false;

  void _clearAll() {
    setState(() {
      otpCode = '';
      circlePinColor1 = Colors.white;
      circlePinColor2 = Colors.white;
      circlePinColor3 = Colors.white;
      circlePinColor4 = Colors.white;
      circlePinColor5 = Colors.white;
      circlePinColor6 = Colors.white;
      circlePin1Controller.clear();
      circlePin2Controller.clear();
      circlePin3Controller.clear();
      circlePin4Controller.clear();
      circlePin5Controller.clear();
      circlePin6Controller.clear();
      FocusScope.of(context).requestFocus(pin1FocusNode);
    });
  }

  // void sendOtpCode() async {
  //   EmailAuth emailAuth = new EmailAuth(sessionName: "Sample session");
  //   bool result =
  //       await emailAuth.sendOtp(recipientMail: widget.email, otpLength: 5);
  // }

  @override
  void initState() {
    super.initState();
    //print(widget.email);
    _sendOtpRequest();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  void changeCircleColor(FocusNode focusNode) {
    if (focusNode == pin2FocusNode) {
      setState(() {
        circlePinColor1 = darkBlueColor;
      });
    } else if (focusNode == pin3FocusNode) {
      setState(() {
        circlePinColor2 = darkBlueColor;
      });
    } else if (focusNode == pin4FocusNode) {
      setState(() {
        circlePinColor3 = darkBlueColor;
      });
    } else if (focusNode == pin5FocusNode) {
      setState(() {
        circlePinColor4 = darkBlueColor;
      });
    } else if (focusNode == pin6FocusNode) {
      setState(() {
        circlePinColor5 = darkBlueColor;
      });
    } else {
      setState(() {
        circlePinColor6 = darkBlueColor;
      });
    }
  }

  void resetCircleColor(FocusNode focusNode) {
    if (focusNode == pin2FocusNode) {
      setState(() {
        circlePinColor1 = Colors.white;
      });
    } else if (focusNode == pin3FocusNode) {
      setState(() {
        circlePinColor2 = Colors.white;
      });
    } else if (focusNode == pin4FocusNode) {
      setState(() {
        circlePinColor3 = Colors.white;
      });
    } else if (focusNode == pin5FocusNode) {
      setState(() {
        circlePinColor4 = Colors.white;
      });
    } else if (focusNode == pin6FocusNode) {
      setState(() {
        circlePinColor5 = Colors.white;
      });
    } else {
      setState(() {
        circlePinColor6 = Colors.white;
      });
    }
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      setState(() {
        focusNode.requestFocus();
        changeCircleColor(focusNode);
      });
    } else if (value.length == 0) {
      focusNode.unfocus();
      focusNode.previousFocus();
    }
  }

  void _sendOtpRequest() {
    print('otp send ...');
    String dummyemail = 'fahadmustafa650@gmail.com';
    try {
      EmailAuth.sessionName = 'Visitor Session';

      EmailAuth.sendOtp(receiverMail: dummyemail);
    } catch (error) {
      print(error);
      print('otp sent error');
      throw error;
    }
  }

  void verifyOtpRequest(BuildContext context) {
    String n1 = circlePin1Controller.text.toString();
    String n2 = circlePin2Controller.text.toString();
    String n3 = circlePin3Controller.text.toString();
    String n4 = circlePin4Controller.text.toString();
    String n5 = circlePin5Controller.text.toString();
    String n6 = circlePin6Controller.text.toString();
    otpCode = '$n1$n2$n3$n4$n5$n6';
    setState(() {
      print('code=$otpCode');
      _isLoading = true;
    });
    var result = EmailAuth.validate(
      receiverMail: widget.email,
      userOTP: otpCode,
    );
    if (timeValue <= 0) {
      Fluttertoast.showToast(
        msg: "Time Passed Resend Code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (result) {
      print('otp verified');
      addData();
    } else {
      Fluttertoast.showToast(
        msg: "Wrong Otp Click On Resend a new code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void addData() async {
    widget.addAllData(context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          "Email Verification",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        color: Colors.lightBlueAccent,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   height: 100,
              //   width: 100,
              //   child: Image.file(widget.visitor.image),
              // ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  'We have sent code to your email',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter your OTP code here",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.normal),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: circlePinColor1,
                    radius: 30,
                    child: TextFormField(
                      autofocus: true,
                      controller: circlePin1Controller,
                      focusNode: pin1FocusNode,
                      //obscureText: true,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        otpCode += value;
                        setState(() {
                          circlePinColor1 = darkBlueColor;
                          nextField(value, pin2FocusNode);
                        });

                        // Then you need to check is the code is correct or not
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: circlePinColor2,
                    radius: 30,
                    child: TextFormField(
                      autofocus: true,
                      // obscureText: true,
                      controller: circlePin2Controller,
                      focusNode: pin2FocusNode,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        otpCode += value;
                        pin2FocusNode.unfocus();
                        otpCode.indexOf(value);

                        setState(() {
                          circlePinColor2 = darkBlueColor;
                          nextField(value, pin3FocusNode);
                        });
                        // Then you need to check is the code is correct or not
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: circlePinColor3,
                    radius: 30,
                    child: TextFormField(
                      autofocus: true,
                      //obscureText: true,
                      controller: circlePin3Controller,
                      focusNode: pin3FocusNode,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        if (value.length == 1) otpCode += value;
                        pin3FocusNode.unfocus();
                        setState(() {
                          circlePinColor3 = darkBlueColor;
                          nextField(value, pin4FocusNode);
                        });
                        // Then you need to check is the code is correct or not
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: circlePinColor4,
                    radius: 30,
                    child: TextFormField(
                      autofocus: true,
                      //obscureText: true,
                      controller: circlePin4Controller,
                      focusNode: pin4FocusNode,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        otpCode += value;

                        pin4FocusNode.unfocus();
                        setState(() {
                          circlePinColor4 = darkBlueColor;
                        });
                        nextField(value, pin5FocusNode);
                        // Then you need to check is the code is correct or not
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: circlePinColor5,
                    radius: 30,
                    child: TextFormField(
                      autofocus: true,
                      controller: circlePin5Controller,
                      focusNode: pin5FocusNode,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        otpCode += value;

                        pin5FocusNode.unfocus();
                        setState(() {
                          circlePinColor5 = darkBlueColor;
                        });
                        nextField(value, pin6FocusNode);
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: circlePinColor6,
                    radius: 30,
                    child: TextFormField(
                      autofocus: true,
                      //obscureText: true,
                      focusNode: pin6FocusNode,
                      controller: circlePin6Controller,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        otpCode += value;

                        pin6FocusNode.unfocus();
                        setState(() {
                          circlePinColor6 = darkBlueColor;
                        });

                        //nextField(value, pin6FocusNode);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              buildTimer(),
              SizedBox(
                height: 25,
              ),
              Container(
                // alignment: Alignment.topLeft,
                child: Text(
                  "Didn't receive any code?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.normal),
                ),
              ),
              _resendCodeBtn(),
              SizedBox(
                height: 10,
              ),
              _sendBtn(context, screenWidth)
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _sendBtn(BuildContext context, double screenWidth) {
    return GestureDetector(
      onTap: () {
        verifyOtpRequest(context);
      },
      child: Container(
        width: screenWidth * 0.35,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1.5),
          color: Colors.blue[700],
        ),
        child: _isLoading
            ? threeBounceSpinkit
            : Center(
                child: Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
      ),
    );
  }

  GestureDetector _resendCodeBtn() {
    return GestureDetector(
      onTap: () {
        // _sendOtpRequest();
        // _clearAll();
        // setState(() {
        //   beginTime = 90.0;
        //   endTime = 0.0;
        // });
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return OtpScreen(email: widget.email, addAllData: widget.addAllData);
        }));
      },
      child: Container(
        //alignment: Alignment.topLeft,
        child: Text(
          "Resend a new code",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildTimer() {
    return TweenAnimationBuilder(
      tween: Tween(begin: beginTime, end: endTime),
      duration: Duration(seconds: 90),
      builder: (_, value, child) {
        timeValue = value.toInt();
        // print(timeValue);
        return Text(
          "Time Left:${value.toInt()}",
          style: TextStyle(color: Colors.white, fontSize: 18),
        );
      },
    );
  }
}
