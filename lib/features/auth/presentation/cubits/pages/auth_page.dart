/*

Auth Page - this page determine whether to show the login or register page

*/

import 'package:flutter/material.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/pages/login_page.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially, show login page
  bool showLoginPage = true;

//toogle between pages
void tooglePages(){
  setState(() {
    showLoginPage = !showLoginPage;
  });
}

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
       return LoginPage(
        togglePages: tooglePages,
       );
    } else{
      return RegisterPage(
        togglePages: tooglePages,
      );
    }
  }
}