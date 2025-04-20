/*

LOGIN PAGE

On this page, an existing user can login with their:
-email
-pw

---------------------------------------------

once the user successfully logs in, they will be redirected to home page.

if user doesn't hace am account yet, they can go to register page from here to
craete one.

*/

import 'package:flutter/material.dart';
import 'package:socialmediaapp/features/auth/presentation/components/my_text_field.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

@override
 State<LoginPage> createState() => _LoginPageState();
 }

 class _LoginPageState extends State<LoginPage> {
  //text controllers
final emailController = TextEditingController();
final pwController =  TextEditingController();

  //build UI
 @override
  Widget build(BuildContext context) {
    //scaffold
    return Scaffold(


//BODY
body: SafeArea(
  child: Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.8),
      child: Column(
        children: [
          //logo 
          Icon(Icons.lock_open_rounded,
        size: 80,
        color: Theme.of(context).colorScheme.primary,
        ),
      
        const SizedBox(height: 50,),
      
        //welcome back msg
        Text("Welcome back, you've been missed! ",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
        ),
        ),
      
      const SizedBox(height: 25,),
      
      
        //email textfield
         MyTextField(
      controller: emailController,
       hintText: "email", 
       obscureText: false,),
        
        const SizedBox(height: 10), 
      
        // pw textfiel
         MyTextField(
      controller: pwController,
       hintText: "password", 
       obscureText: true,),

       
      
        //login button
      
        //not a member?? register now
        ],
      ),
    ),
  ),
),
    );
  }
 }