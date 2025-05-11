import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/domain/entities/profile_user.dart';
import 'package:socialmediaapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/profile_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  // mobile image pick
  PlatformFile? imagePickedFile;

// web image pick
  Uint8List? webImage;

// bio text controller
  final bioTextController = TextEditingController();

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      // if withData it's true, binary data will be added into the result as a property for web files handling
      withData:
          kIsWeb, // KIsWeb is a boolean that specifies if the is running on the web
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        // possibly useless check
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // update profile button pressed
  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();
// prepare images & data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

// only update profile if there is something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }
// nothing to update -> go to previous page
    else {
      Navigator.pop(context);
    }
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // save button
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.upload),
          ), // IconButton
        ],
      ), // AppBar
      body: Column(
        children: [
// profile picture
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              // BoxDecoration
              clipBehavior: Clip.hardEdge,
              child:
                  // display selected image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(File(imagePickedFile!.path!))
                      :
                      // display selected image for web
                      (kIsWeb && webImage != null)
                          ? Image.memory(webImage!)
                          :
                          // no image selected -> display existing profile pic
                          CachedNetworkImage(
                              imageUrl: widget.user.profileImageUrl,
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
                                  Image(image: imageProvider),
                            fit: BoxFit.cover,
                            ), // CachedNetworkImage
            ), // Container
          ), // Center

          const SizedBox(
            height: 25,
          ),

          // pick image button
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ), // MaterialButton
          ), // Center

          const SizedBox(
            height: 25,
          ),
          // bio
          const Text("Bio"),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obscureText: false,
            ), // MyTextField
          ), // Padding
        ],
      ), // Column
    ); // Scaffold
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // profile loading..
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading..."),
                ],
              ),
            ), // Column
          ); // Scaffold
        } else {
          // edit form
          return buildEditPage();
        }
      },
      listener: (context, state) {},
    );
  }
}
