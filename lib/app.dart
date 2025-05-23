import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/data/firebase_auth_repo.dart';
import 'package:socialmediaapp/features/auth/data/firebase_profile_repo.dart';
import 'package:socialmediaapp/features/auth/data/firebase_storage_repo.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/auth.states.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/pages/auth_page.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/post_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/profile_cubit.dart';
import 'package:socialmediaapp/features/auth/themes/light_mode.dart';
import 'package:socialmediaapp/features/post/presentation/pages/home_page.dart';
import 'package:socialmediaapp/features/profile/data/firebase_post_repo.dart';

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
  final firebaseAuthRepo = FirebaseAuthRepo();

  //profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();

  //storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();

  //post repo
  final firebasePostRepo = FirebasePostRepo(); 

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provide cubits to app
    return MultiBlocProvider(
    providers: [
      
      BlocProvider<AuthCubit>(create:(context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth()
      ),
      //profile cubit
      BlocProvider<ProfileCubit>(create:(context) => ProfileCubit(
        profileRepo: firebaseProfileRepo,
        storageRepo: firebaseStorageRepo 
        ),
        ),

        //post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo, 
            storageRepo: firebaseStorageRepo),
        ),
    ],
    child:  MaterialApp(
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
    ),);
  }
}