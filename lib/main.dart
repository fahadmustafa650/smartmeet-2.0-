import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Employee/employee_screens/emp_sign_in_screen.dart';
import 'package:smart_meet/Employee/employee_screens/employee_home_screen.dart';
import 'package:smart_meet/providers/firebase_messaging_provider.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'Employee/EmployeeForgetPassword/employee_enter_email_screen.dart';
import 'Employee/employee_screens/appointment_requests_screen.dart';
import 'Employee/employee_screens/emp_sign_up_screen.dart';
import 'Employee/employee_screens/employee_booked_appointment_screen.dart';
import 'Employee/employee_screens/employee_edit_profile_screen.dart';
import 'Visitor/Appointment/appointment_sent_screen.dart';
import 'Visitor/Appointment/visitor_pending_appointments_screen.dart';
import 'Visitor/Appointment/request_appoinment_screen.dart';
import 'Visitor/Appointment/search_employee_screen.dart';
import 'Visitor/Appointment/visitor_booked_appointment_screen.dart';
import 'Visitor/Device steps/facial_recognition_step3.dart';
import 'Visitor/Device steps/temperature_detector_step2.dart';
import 'Visitor/RunInAppointment/run_in_appointment_screen.dart';
import 'Visitor/RunInAppointment/search_employee_screen.dart';
import 'Visitor/Visitor Authentication/visitor_edit_profile_screen.dart';
import 'Visitor/Visitor Authentication/visitor_sign_in_screen.dart';
import 'Visitor/Visitor Authentication/visitor_sign_up_screen.dart';
import 'Visitor/Visitor Verification Steps/mask_detection_step4.dart';
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
import 'screens/login_as_screen.dart';
import 'Employee/employee_screens/employee_pending_appointments_screen.dart';
import 'screens/onboarding_screens.dart';
import 'screens/splash_screen.dart';
import 'screens/sign_up_as_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/test_notification_screen.dart';

// Future<void> _firebaseMessagingBackgroundHandler(
//     RemoteMessage remoteMessage) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up : ${remoteMessage.messageId}');
// }
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessagingProvider.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseMessagingProvider()),
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
        home: RunInEmployeeSearchBarScreen(),
        // NotificationTestScreen(),
        // RunInAppointmentScreen(
        //   employeeId: '6162a334b583f90004c1438f',
        // ),
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
          RunInAppointmentScreen.id: (context) => RunInAppointmentScreen(),
          // ScanQRCodeStep1.id: (context) => ScanQRCodeStep1(),
          SignUpAsScreen.id: (context) => SignUpAsScreen(),
          //PasswordChangedSuccess.id: (context) => PasswordChangedSuccess(),
          TemperatureDetectionStep3.id: (context) =>
              TemperatureDetectionStep3(),
          VisitorHomeScreen.id: (context) => VisitorHomeScreen(),
          VisitorEditProfileScreen.id: (context) => VisitorEditProfileScreen(),
          VisitorEnterEmailScreen.id: (context) => VisitorEnterEmailScreen(),
          VisitorSignInScreen.id: (context) => VisitorSignInScreen(),
          VisitorSignUpScreen.id: (context) => VisitorSignUpScreen(),
          VisitorPendingAppointmentsScreen.id: (context) =>
              VisitorPendingAppointmentsScreen(),
          EmployeeSignInScreen.id: (context) => EmployeeSignInScreen(),
        },
      ),
    );
  }
}
