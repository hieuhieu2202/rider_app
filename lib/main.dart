
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'global/global.dart';

// Import the generated file
// Import the generated file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharePreferences = await SharedPreferences.getInstance();
  // Dòng này đảm bảo rằng các liên kết của framework
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

   );
  // Flutter được khởi tạo trước khi ứng dụng chạy
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ridder ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MySplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
