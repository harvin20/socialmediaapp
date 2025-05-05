/*

PROFILE STATES

*/
import 'package:flutter/foundation.dart';

abstract class PostState {}

// initial
class PostsInitial extends PostState {
  PostsInitial() {
    if (kDebugMode) {
      print(PostsInitial);
    }
  }
}

// loading..
class PostsLoading extends PostState {
  PostsLoading() {
    if (kDebugMode) {
      print(PostsLoading);
    }
  }
}

// uploading..
class PostUploading extends PostState {
  PostUploading() {
    if (kDebugMode) {
      print(PostUploading);
    }
  }
}

// error
class PostsError extends PostState {
  final String message;

  PostsError(this.message) {
    if (kDebugMode) {
      print(PostsError);
    }
  }
}

// loaded
class PostsLoaded extends PostState {
  final List<Post> posts;

  PostsLoaded(this.posts) {
    if (kDebugMode) {
      print(PostsLoaded);
    }
  }
}