import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/domain/entities/app_user.dart';
import 'package:socialmediaapp/features/auth/domain/entities/profile_user.dart';
import 'package:socialmediaapp/features/auth/presentation/components/bio_box.dart';
import 'package:socialmediaapp/features/auth/presentation/components/follow_button.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/pages/edit_profile_page.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/profile_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/profile_states.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //current user
  late AppUser? currentUser = authCubit.currentUser;
  //posts
  int postCount = 0;

  //on startup
  @override
  void initState() {
    super.initState();

    //load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }
  

  /*

FOLLOW / UNFOLLOW

  */

  void followButtonPressed(){
    final ProfileState = profileCubit.state;
    if(ProfileState is! ProfileLoaded){
      return; // return is profile is not loaded
    }
    final ProfileUser = ProfileState.profileUser;
    final isFollowing =ProfileUser.followers.contains(currentUser!.uid);

    profileCubit.toggleFollow(currentUser!.uid, widget.uid);
  }




  // BUILD UI
  @override
  Widget build(BuildContext context) {

 //is own post

 bool isOwnPost = widget.uid == currentUser!.uid;




    //SCAFFOLD
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoaded) {
          //get loaded user
          final user = state.profileUser;

          //SCAFFOLD
          return Scaffold(
            //APP BAR
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                //edit profile button

                if(isOwnPost)
                IconButton(
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => EditProfilePage (user: user,),
                  )),
                 icon: const Icon(Icons.settings)
                 )
              ],
            
            ),

            //BODY
            body: 
              Column(
                children: [
                  //email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 25),
                  //profile pic
                   CachedNetworkImage(
                              imageUrl: user.profileImageUrl,
                              // loading..
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),

                              // error -> failed to load
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 72,
                                color: Theme.of(context).colorScheme.primary,
                              ), // Icon

                              // loaded
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                       fit: BoxFit.cover,
                                      )
                                      ),
                                    ),
                                  ),
                                    
                       const SizedBox(height: 25,),
                       //follow button
                       if(!isOwnPost)
                       FollowButton(
                        onPressed:followButtonPressed,
                         isFollowing:user.followers.contains(currentUser!.uid), 
                         ),
              
                  //bio box
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Text("Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),),
                      ],
                    ),
                  ),
                   const SizedBox(height: 25),

                  BioBox(text: user.bio),

                  //posts
                   Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 25),
                    child: Row(
                      children: [
                        Text(
                          "posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),),
                      ],
                    ),
                  ),
                ],
              ),
            );
        }
      
        //loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Center(child: Text("No profile Found..."));
        }
      },
    );
  }
}
