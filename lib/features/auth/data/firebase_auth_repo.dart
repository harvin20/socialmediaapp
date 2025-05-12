import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmediaapp/features/auth/domain/entities/app_user.dart';
import 'package:socialmediaapp/features/auth/domain/entities/repos/auth_repo.dart';

class FirebaseAuthRepo  implements AuthRepo{

 final FirebaseAuth firebaseAuth = FirebaseAuth.instance; 
 final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
@override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async{
  try{
//attenpt sign in 
UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
  email: email, password: password);
  //fecth user document from firestore
  DocumentSnapshot userDoc =
   await firebaseFirestore.collection('users')
  .doc(userCredential.user!.uid)
  .get();
// create user
AppUser user = AppUser(uid: userCredential.user!.uid, 
email: email, 
name: userDoc['name']
);
// return user
return user; 
 }
 
 //catch any errors
 catch(e){
  throw Exception('login failed: $e');
 }
  
 }
  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password) async{
    try{
//attenpt sign up 
UserCredential userCredential = await firebaseAuth.
createUserWithEmailAndPassword(email: email, password: password);
// create user
AppUser user = AppUser(uid: userCredential.user!.uid, 
email: email, 
name: name,
);
// return user
return user; 
 }
 
 //catch any errors
 catch(e){
  throw Exception('login failed: $e');
 }

  }
@override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }


@override
  Future<AppUser?> getCurrentUser() async {

    // get current logged in user frorm firebase 
   final firebaseUser = firebaseAuth.currentUser;
//not user logged in...
   if (firebaseUser == null){
    return null;
   }

   //fetc user document from firestorer
   DocumentSnapshot userDoc = await firebaseFirestore.collection("users").doc(firebaseUser.uid).get();
//check if user doc exist
if(!userDoc.exists){
  return null;
}
   // user exist 
   return AppUser(
  uid:firebaseUser.uid, 
   email: firebaseUser.email!, 
   name: userDoc['name'],
   );
 }
}