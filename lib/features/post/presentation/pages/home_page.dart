import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmediaapp/features/auth/presentation/components/my_drawer.dart';
import 'package:socialmediaapp/features/post/presentation/components/post_tile.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/post_cubit.dart';
import 'package:socialmediaapp/features/auth/presentation/cubits/post_state.dart';
import 'package:socialmediaapp/features/profile/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //post cubit 
  late final postCubit = context.read<PostCubit>();
//on startup

@override
  void initState() {
    super.initState();

    //fetch all posts
    fetchAllPosts();
  }
  void fetchAllPosts(){
    postCubit.fetchAllPosts();
  }
  void delete(String postId){
    postCubit.deletePost(postId);
    fetchAllPosts();
  }



  //BUILD UI
  @override
  Widget build(BuildContext context) {

    //SCAFFOLD 
    return Scaffold(

      //APP BAR
      appBar: AppBar(
        title: Center (
          child:  Text("Home"),),
          foregroundColor: Theme.of(context).colorScheme.primary,
          actions: [
             //upload new button
             IconButton(onPressed: () => Navigator.push(context,MaterialPageRoute(builder:(context) => const UploadPostPage(),
              )) , 
             icon: const Icon(Icons.add),)
          ],
        ),

      //DRAWER 
      drawer: const MyDrawer(),

      // BODY
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // loading..
          if (state is PostsLoading && state is PostUploading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(child: Text("No posts available"));
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                // get individual post
                final post = allPosts[index];
                // image
                return PostTile(
                  post: post,
                  onDeletePressed: () => (post.id),
                ); // CachedNetworkImage
              },
            ); // L
          }

          // error
          else if (state is PostsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}