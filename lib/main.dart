import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Employee/employee_screens/employee_home_screen.dart';
import 'package:smart_meet/models/message_model.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'Employee/EmployeeForgetPassword/employee_enter_email_screen.dart';
import 'Employee/EmployeeForgetPassword/employee_new_password_screen.dart';
import 'Employee/employee_screens/appointment_requests_screen.dart';
import 'Employee/employee_screens/emp_sign_in_screen.dart';
import 'Employee/employee_screens/emp_sign_up_screen.dart';
import 'Employee/employee_screens/employee_booked_appointment.dart';
import 'Employee/employee_screens/employee_edit_profile_screen.dart';
import 'Employee/employee_screens/employee_map_location_marker.dart';
import 'Visitor/Appointment/appointment_sent_screen.dart';
import 'Visitor/Appointment/visitor_pending_appointments_screen.dart';
import 'Visitor/Appointment/request_appoinment_screen.dart';
import 'Visitor/Appointment/reserve_spot_employee_screen.dart';
import 'Visitor/Appointment/search_employee_screen.dart';
import 'Visitor/Appointment/visitor_booked_appointment_screen.dart';
import 'Visitor/Appointment/search_result_screen.dart';
import 'Visitor/Device steps/facial_recognition_step3.dart';
import 'Visitor/Device steps/temperature_detector_step2.dart';
import 'Visitor/Visitor Authentication/visitor_edit_profile_screen.dart';
import 'Visitor/Visitor Authentication/visitor_sign_in_screen.dart';
import 'Visitor/Visitor Authentication/visitor_sign_up_screen.dart';
import 'Visitor/Visitor Verification Steps/mask_detection_step4.dart';
import 'Visitor/Visitor Verification Steps/qr_code_step1.dart';
import 'Visitor/VisitorForgetPassword/visitor_enter_email_screen.dart';
import 'Visitor/visitor_home_screen.dart';
import 'providers/employee_booked_appointment_provider.dart';
import 'providers/employee_office_location_provider.dart';
import 'providers/employee_pending_appointments_provider.dart';
import 'providers/employee_auth.dart';
import 'providers/employee_provider.dart';
import 'providers/visitor_booked_appointments_providers.dart';
import 'providers/visitor_pending_appointments_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/chating_screen.dart';
import 'screens/contact_us.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/google_map_search_test.dart';
import 'screens/login_as_screen.dart';
import 'Employee/employee_screens/employee_pending_appointments_screen.dart';
import 'screens/map_screen.dart';
import 'screens/onboarding_screens.dart';
import 'screens/otp_screen.dart';
import 'screens/password_changed_successfully.dart';
import 'screens/qr_code_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/sign_up_as_screen.dart';
import 'screens/test_api.dart';
import 'screens/test_image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/test_ocr.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Channel',
  'This Channel is used for important notifications',
  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  print('A bg message just showed up : ${remoteMessage.messageId}');
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: VisitorProvider(),
        ),
        ChangeNotifierProvider.value(
          value: EmployeePendingAppointmentsRequestsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: EmployeesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: VisitorAcceptedAppointmentRequestsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: VisitorPendingAppointmentsRequestsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: EmployeeAuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: EmployeeBookedAppointmentsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: EmployeeOfficeLocationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowMaterialGrid: false,
        home: MapSample(),
        // initialRoute: RequestAppointmentScreen.id,
        debugShowCheckedModeBanner: false,
        routes: {
          AppointmentRequestsScreen.id: (context) =>
              AppointmentRequestsScreen(),
          AppointmentSentScreen.id: (context) => AppointmentSentScreen(),
          BookedAppointmentsScreen.id: (context) => BookedAppointmentsScreen(),
          ChatingScreen.id: (context) => ChatingScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          ContactUs.id: (context) => ContactUs(),
          CustomSplashScreen.id: (context) => CustomSplashScreen(),
          EditProfileScreen.id: (context) => EditProfileScreen(),
          EmployeeSearchBar.id: (context) => EmployeeSearchBar(),
          EmployeeHomeScreen.id: (context) => EmployeeHomeScreen(),
          EmployeeSignUpScreen.id: (context) => EmployeeSignUpScreen(),
          EmployeeEditProfileScreen.id: (context) =>
              EmployeeEditProfileScreen(),
          EmployeeBookedAppointmentsScreen.id: (context) =>
              EmployeeBookedAppointmentsScreen(),
          EmployeePendingAppointmentsScreen.id: (context) =>
              EmployeePendingAppointmentsScreen(),
          VisitorEnterEmailScreen.id: (context) => VisitorEnterEmailScreen(),
          EmployeeEnterEmailScreen.id: (context) => EmployeeEnterEmailScreen(),
          FacialRecognitionStep3.id: (context) => FacialRecognitionStep3(),
          LoginAsScreen.id: (context) => LoginAsScreen(),
          //MapScreen.id: (context) => MapScreen(),
          MaskDetectionStep4.id: (context) => MaskDetectionStep4(),
          OnBoardingScreens.id: (context) => OnBoardingScreens(),
          RequestAppointmentScreen.id: (context) => RequestAppointmentScreen(),
          ReserveEmployeeSpotScreen.id: (context) =>
              ReserveEmployeeSpotScreen(),
          ScanQRCodeStep1.id: (context) => ScanQRCodeStep1(),
          SignUpAsScreen.id: (context) => SignUpAsScreen(),
          //PasswordChangedSuccess.id: (context) => PasswordChangedSuccess(),
          TemperatureDetectionStep3.id: (context) =>
              TemperatureDetectionStep3(),
          VisitorHomeScreen.id: (context) => VisitorHomeScreen(),
          VisitorEditProfileScreen.id: (context) => VisitorEditProfileScreen(),
          VisitorEnterEmailScreen.id: (context) => VisitorEnterEmailScreen(),
          //VisitorSignInScreen.id: (context) => VisitorSignInScreen(),
          VisitorSignUpScreen.id: (context) => VisitorSignUpScreen(),
          VisitorPendingAppointmentsScreen.id: (context) =>
              VisitorPendingAppointmentsScreen(),
        },
      ),
    );
  }
}

class TestScreen extends StatefulWidget {
  TestScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onBackgroundMessage((message) {
      return null;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
      0,
      "Testing $_counter",
      "How you doing ?",
      NotificationDetails(
        android: AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            importance: Importance.high,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Title'),
      ),
      body: Center(
        child: Text(
          'You have pushed the button this many times: \n$_counter',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
