/*

Profile Repository 

*/

import 'package:socialmediaapp/features/auth/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updateProfile);
  Future<void>toggleFollow(String currentUid, String targetUid);

}
