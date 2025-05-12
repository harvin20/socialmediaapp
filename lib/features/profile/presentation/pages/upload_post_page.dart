

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/domain/entities/app_user.dart';
import 'package:socialmediaapp/features/auth/domain/entities/profile_user.dart';
import 'package:socialmediaapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/post_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/post_state.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/profile_cubit.dart';
import 'package:socialmediaapp/features/profile/domain/entities/post.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {

  // mobile image pick
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  // text controller -> caption
  final textController = TextEditingController();

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? userProfile;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchUserProfile();
  }

// get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> fetchUserProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    final fetchedUser = await profileCubit.getUserProfile(currentUser!.uid);
    if (fetchedUser != null) {
      setState(() {
        userProfile = fetchedUser;
      });
    }
  }

// pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        print(imagePickedFile);
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

// create & upload post
  void uploadPost() {
    // check if both image and caption are provided
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both image and caption are required")),
      );
      return;
    }

    // create a new post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: userProfile!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    ); // Post

// post cubit
    final postCubit = context.read<PostCubit>();

// web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }

// mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }

    @override
    void dispose() {
      textController.dispose();
      super.dispose();
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        // loading or uploading..
        if (state is PostsLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ), // Center
          ); // Scaffold
        }

        // build upload page
        return buildUploadPage();
      },
      // go to previous page when upload is done & posts are loaded
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    ); // BlocConsumer
  }

  Widget buildUploadPage() {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload button
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          ), // IconButton
        ],
      ), // AppBar

      // BODY
      body: Center(
        child: Column(
          children: [
            // image preview for web
            if (kIsWeb && webImage != null)
              Image.memory(
                webImage!,
                width: double.infinity,
                height: 300,
              ),

            // image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!),height: 150,),

            // pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ), // MaterialButton

// caption text box
            MyTextField(
              controller: textController,
              hintText: "Caption",
              obscureText: false,
            ), // MyTextField
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}
