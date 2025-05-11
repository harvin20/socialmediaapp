
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/domain/repos/profile_repo.dart';
import 'package:socialmediaapp/features/auth/domain/storage_repo.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/profile_states.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit(
      {required this.profileRepo, 
      required this.storageRepo})
      : super(ProfileInitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      
      if (user != null) {
          emit(ProfileLoaded(user));
      }else {
        emit(ProfileError("User not found"));
      }
      

    }catch(e) {
      emit(ProfileError(e.toString()));
    }
  }

  //update bio and profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async{
    emit(ProfileLoading());

    try{
      //fectch current profile first
      final currentUser = await profileRepo.fetchUserProfile(uid);
   if (currentUser == null ) {
    emit(ProfileError("failed to fetch user for profile updtae"));
    return; 
   }

   //profile picture update
   String? imageDownloadUrl;

   //if ensure there is an image
   if (imageWebBytes != null || imageMobilePath != null){
//for mobile
   if (imageMobilePath != null){
    //upload
      imageDownloadUrl = 
      await storageRepo.uploadPostImageMobile(imageMobilePath, uid);
   }
   else if (imageWebBytes != null) {
//upload
imageDownloadUrl =
   await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
   }
    if (imageDownloadUrl ==null ) {
      emit (ProfileError("failed to upload image"));
      return; 
    }
   }

   //update new profile
   final updatedProfile = currentUser.copyWith(
    newBio: newBio ?? currentUser.bio,
    newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
    );
    
    //update in repo
   await profileRepo.updateProfile(updatedProfile);

   //re-fetch the updated profile
    }
    catch(e) {
    emit(ProfileError("error updating profile: $e"));
    }
  }

}