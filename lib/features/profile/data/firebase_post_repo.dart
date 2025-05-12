import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmediaapp/features/profile/domain/entities/comments.dart';
import 'package:socialmediaapp/features/profile/domain/entities/post.dart';
import 'package:socialmediaapp/features/profile/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection = 
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final snapshot = await postsCollection.orderBy("timestamp", descending: true).get();
      return snapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      final snapshot = await postsCollection.where('userId', isEqualTo: userId).get();
      return snapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching user posts: $e");
    }
  }
  
  @override
  Future<void> deleteComment(String postId, String commentId) async {
       try{
//get post document
final postDoc = await postsCollection.doc(postId).get();
if (postDoc.exists){
  //convert json object -> post
  final post = Post.fromJson(postDoc.data() as Map<String,dynamic>);
  //add the new
  post.comments.removeWhere((comment) => comment.id == commentId);
  //update the post document in firestore
  await postsCollection.doc(postId).update({
    'comments': post.comments.map((comment) => comment.toJson()).toList()
  });
} else{
  throw Exception("Post not found");
}
    } catch(e){
      throw Exception("Error deleting comment: $e");
    }
  }
  
  @override
  Future<void> toggleLikePost(String postId, String userId) async {
  try{
    //get the past document from firestore 
    final postDoc = await postsCollection.doc(postId).get();
    if (postDoc.exists){
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      //check if user has already like this post
      final hasliked = post.likes.contains(userId);
      //update the likes list
      if (hasliked){
        post.likes.remove(userId); //unlike
      } else {
        post.likes.add(userId); //like
      }
      //update the post document with the new like list
      await postsCollection.doc(postId).update({
        'likes': post.likes,
      });
    } else{
      throw Exception("post not founf");
    }
  }
  catch(e) {
    throw Exception("Error toggling like: $e");
  }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try{
//get post document
final postDoc = await postsCollection.doc(postId).get();
if (postDoc.exists){
  //convert json object -> post
  final post = Post.fromJson(postDoc.data() as Map<String,dynamic>);
  //add the new
  post.comments.add(comment);
  //update the post document in firestore
  await postsCollection.doc(postId).update({
    'comments': post.comments.map((comment) => comment.toJson()).toList()
  });
} else{
  throw Exception("Post not found");
}
    } catch(e){
      throw Exception("Error adding comment: $e");
    }
  }
}