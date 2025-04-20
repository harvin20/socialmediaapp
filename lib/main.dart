import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/pages/login_page.dart';
import 'package:socialmediaapp/features/auth/themes/light_mode.dart';
import 'package:socialmediaapp/firebase_options.dart';

void main() async{
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //run app
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: LoginPage(),
    );
  }
}