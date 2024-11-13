import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/all_bookings_page.dart';
import 'package:shipping_app/all_inventory_page.dart';
import 'package:shipping_app/firebase_options.dart';
import 'package:shipping_app/homepage.dart';
import 'package:shipping_app/login_page.dart';
import 'package:shipping_app/new_booking_page.dart';
import 'package:shipping_app/new_inventory_page.dart';
import 'package:shipping_app/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipping App',
      routes: {
        '/loginpage': (BuildContext context) => const LoginPage(),
        '/homepage': (BuildContext context) => HomeScreen(),
        '/register': (BuildContext context) => const RegistrationPage(),
        '/allbookingspage': (BuildContext context) => const AllBookingsPage(),
        '/newbookingspage': (BuildContext context) => const NewBookingPage(),
        '/allinventorypage': (BuildContext context) => const AllInventoryPage(),
        '/newinventorypage': (BuildContext context) => const NewInventoryPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          elevation: 0, // Remove shadow
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white,
          secondary: Colors.grey,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 125, 125, 125), // Text color
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,             // Cursor color
          selectionColor: Colors.grey[300],      // Text selection color (highlight)
          selectionHandleColor: Colors.black,    // Selection handle color
        ),
      ),
      home: const LoginPage(),
    );
  }
}
