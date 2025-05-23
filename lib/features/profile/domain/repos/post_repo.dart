
import 'package:socialmediaapp/features/profile/domain/entities/comments.dart';
import 'package:socialmediaapp/features/profile/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();

  Future<void> createPost(Post post);

  Future<void> deletePost(String postId);

  Future<List<Post>> fetchPostsByUserId(String userId);

  Future<void> toggleLikePost(String postId, String userId);

  Future<void> deleteComment(String postId, String commentId);

  Future<void> addComment(String postId, Comment comment);
}
