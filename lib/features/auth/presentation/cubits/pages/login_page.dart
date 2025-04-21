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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/presentation/components/my_button.dart';
import 'package:socialmediaapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/auth_cubit.dart';


class LoginPage extends StatefulWidget{
  final void Function()? togglePages;
  
  const LoginPage({super.key, required this.togglePages});

@override
 State<LoginPage> createState() => _LoginPageState();
 }

 class _LoginPageState extends State<LoginPage> {
  //text controllers
final emailController = TextEditingController();
final pwController =  TextEditingController();

//login button pressed
void login(){
  //prepare email & pw
  final String email = emailController.text;
  final String pw = pwController.text; 
  
  //auth cubit
  final authCubit = context.read<AuthCubit>();

  //ensure that the email & pw fiels are not empty
  if (email.isNotEmpty && pw.isNotEmpty){
    // login!
    authCubit.login(email, pw);
  }
  //display error if some fields are empty
  else{
    ScaffoldMessenger.of(context).showSnackBar(const  SnackBar(content: Text('please enter both emsil and password')));
  }
}
@override
  void dispose() {
   emailController.dispose();
   pwController.dispose();
    super.dispose();
  }


  //build UI
 @override
  Widget build(BuildContext context) {
    //scaffold
    return Scaffold(
//BODY
body: SafeArea(
  child: Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
       obscureText: true,
       ),

        const SizedBox(height: 25,),
      
        //login button
      MyButton(
        onTap: login,
       text: "login"
       ),
       const SizedBox(height: 50,),
      
        //not a member?? register now
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text(
                "Not a member?",
              style: 
                    TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
                 GestureDetector(
                  onTap:widget.togglePages,
                   child: Text(
                                   "Register now",
                                 style: 
                      TextStyle(color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      )
                                 ),
                 ),
          ],
        )
        ],
      ),
    ),
  ),
),
    );
  }
}