import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meet/Employee/employee_screens/employee_profile_screen.dart';
import 'package:smart_meet/providers/visitor_provider.dart';
import 'package:smart_meet/widgets/appointment_request.dart';
import 'Employee/employee_screens/appointment_requests_screen.dart';
import 'Employee/employee_screens/emp_sign_in_screen.dart';
import 'Employee/employee_screens/emp_sign_up_screen.dart';
import 'Visitor/Appointment/appointment_sent_screen.dart';
import 'Visitor/Appointment/pending_appointments_screen.dart';
import 'Visitor/Appointment/request_appoinment_screen.dart';
import 'Visitor/Appointment/reserve_spot_employee_screen.dart';
import 'Visitor/Appointment/search_employee_screen.dart';
import 'Visitor/Appointment/visitor_booked_appointment_screen.dart';
import 'Visitor/Appointment/search_result_screen.dart';
import 'Visitor/Device steps/facial_recognition_step3.dart';
import 'Visitor/Device steps/temperature_detector_step2.dart';
import 'Visitor/Visitor Authentication/visitor_sign_in_screen.dart';
import 'Visitor/Visitor Authentication/visitor_sign_up_screen.dart';
import 'Visitor/Visitor Verification Steps/mask_detection_step4.dart';
import 'Visitor/Visitor Verification Steps/qr_code_step1.dart';
import 'Visitor/visitor_home_screen.dart';
import 'providers/appointments_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/visitor_booked_appointments_providers.dart';
import 'providers/visitor_pending_appointments.dart';
import 'screens/chat_screen.dart';
import 'screens/chating_screen.dart';
import 'screens/contact_us.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/enter_email_screen.dart';
import 'screens/login_as_screen.dart';
import 'Employee/employee_screens/employee_pending_screen.dart';
import 'screens/onboarding_screens.dart';
import 'screens/password_changed_successfully.dart';
import 'screens/qr_code_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/sign_up_as_screen.dart';
import 'screens/test_api.dart';

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
          value: AcceptedAppointmentRequestsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: VisitorPendingAppointmentsRequestsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowMaterialGrid: false,
        home: EmployeeSignInScreen(),
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
          EmployeePendingAppointments.id: (context) =>
              EmployeePendingAppointments(),
          EmployeeSearchResultScreen.id: (context) =>
              EmployeeSearchResultScreen(),
          EmployeeSignInScreen.id: (context) => EmployeeSignInScreen(),
          EmployeeSignUpScreen.id: (context) => EmployeeSignUpScreen(),
          EnterEmailScreen.id: (context) => EnterEmailScreen(),
          FacialRecognitionStep3.id: (context) => FacialRecognitionStep3(),
          LoginAsScreen.id: (context) => LoginAsScreen(),
          //MapScreen.id: (context) => MapScreen(),
          MaskDetectionStep4.id: (context) => MaskDetectionStep4(),
          VisitorPendingAppointmentsScreen.id: (context) =>
              VisitorPendingAppointmentsScreen(),
          OnBoardingScreens.id: (context) => OnBoardingScreens(),
          RequestAppointmentScreen.id: (context) => RequestAppointmentScreen(),
          ReserveEmployeeSpotScreen.id: (context) =>
              ReserveEmployeeSpotScreen(),
          ScanQRCodeStep1.id: (context) => ScanQRCodeStep1(),
          SignUpAsScreen.id: (context) => SignUpAsScreen(),
          PasswordChanged.id: (context) => PasswordChanged(),
          TemperatureDetectionStep3.id: (context) =>
              TemperatureDetectionStep3(),
          VisitorHomeScreen.id: (context) => VisitorHomeScreen(),
          VisitorSignInScreen.id: (context) => VisitorSignInScreen(),
          VisitorSignUpScreen.id: (context) => VisitorSignUpScreen(),
        },
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppointmentRequest(),
      ),
    );
  }
}
