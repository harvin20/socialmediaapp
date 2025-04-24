import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/data/firebase_auth_repo.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/auth.states.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/pages/auth_page.dart';
import 'package:socialmediaapp/features/auth/themes/light_mode.dart';
import 'package:socialmediaapp/features/post/presentation/pages/home_page.dart';
/*


app- Root Level

----------------------------------------------------

 Repositories: for the database 
 -firebase

 Bloc providiers: for state management 
 -auth
 -profile
 -post
 -search
 -theme

 Check Auth State
 -unauthenticated
 -aunthenticated -> homepage


*/


class MyApp extends StatelessWidget {

  //auth repo
  final authRepo = FirebaseAuthRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provide cubit to app
    return  BlocProvider
    (create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: BlocConsumer<AuthCubit, AuthState>(
        builder: (context, authState) {
          print(authState);
           // unauthenticated -> auth page(login/register)
        if(authState is Unauthenticated){
          return const AuthPage();
          }

          //authenticated
          if (authState is Authenticaded){
            return const HomePage();
          }

          //loading...
          else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          }

        },

        //listen for errors...
        listener: (context, state){
          if(state is AuthError){
            ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(content: Text(state.message) ));
          }
        },
        ),
    ),
    );
  }
}