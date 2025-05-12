import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmediaapp/features/auth/domain/entities/profile_user.dart';
import 'package:socialmediaapp/features/auth/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo{

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
@override
Future<ProfileUser> fetchUserProfile(String uid) async {
  try {
    final userDoc = await firebaseFirestore.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data();

      if (userData != null) {
        //fetch followers & following
        final followers = List<String>.from(userData['followers']??[]);
        final following = List<String>.from(userData['following']??[]);

        return ProfileUser(
          uid: uid, 
          email: userData['email'],
          name: userData['name'],
          bio: userData['bio'] ?? '',
          profileImageUrl: userData['profileImageUrl'].toString(),
          followers: followers,
          following: following,
        );
      }
    }
    throw Exception('User not found or data is incomplete');
  } catch (e) {
    throw Exception('Failed to fetch user profile: ${e.toString()}');
  }
}
   


  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      //convert updated profile to json store in firestore
      await firebaseFirestore 
      .collection('users')
      .doc(updateProfile.uid)
      .update({
        'bio': updateProfile.bio,
        'profileImageUrl': updateProfile.profileImageUrl,
      });
    }catch (e) {
      throw Exception(e);
    }
}

  @override
  Future<void> toggleFollow(String currentUid, String targetUid)async{
    try {
      final currentUserDoc = 
      await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc = 
      await firebaseFirestore.collection('users').doc(targetUid).get();

      if(currentUserDoc.exists && targetUserDoc.exists){

        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null){
               List<String>.from(currentUserData['following'] ?? []);

          // check if the current user is already following the target user
          if (currentFollowing(targetUid)) {
            // unfollow
            // FieldValue is used here for removing/adding data to a field (array, object,...) only if is present/missing
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });

            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            // follow
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });

            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });

          }

        }
      }
    } catch (e) {}
  }
}

