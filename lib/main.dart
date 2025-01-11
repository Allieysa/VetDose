import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vetdose/calculator%20screen/calculator_screen.dart';
import 'package:vetdose/converter%20screen/converter_first_screen.dart';
import 'package:vetdose/main%20page/controller.dart';
import 'package:vetdose/main%20page/main_screen.dart';
import 'package:vetdose/profile%20screen/patient_list.dart';
import 'package:vetdose/profile%20screen/profile_screen.dart';
import 'package:vetdose/utils/instant_page_route.dart';
import 'splash_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VetDose',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/splash':
            page = SplashScreen();
            break;
          case '/login':
            page = LoginScreen();
            break;
          case '/home':
            page = MainScreen(controller: controller, currentIndex: 2);
            break;
          case '/calculator':
            page = CalculatorScreen(controller: controller, currentIndex: 0);
            break;
          case '/converter':
            page = ConverterScreen(controller: controller, currentIndex: 1);
            break;
          case '/patient':
            page = PatientHistoryScreen(controller: controller, currentIndex: 3);
            break;
          case '/profile':
            page = ProfileScreen(controller: controller, currentIndex: 4);
            break;
          default:
            page = SplashScreen();
        }
        return InstantPageRoute(page: page);
        },
        );
        }
}
