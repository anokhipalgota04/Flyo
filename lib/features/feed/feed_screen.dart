



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/common/error_text.dart';
import 'package:flutter_application_1/core/common/loader.dart';
import 'package:flutter_application_1/core/common/post_card.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/community/controller/community_controller.dart';
import 'package:flutter_application_1/features/posts/controller/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
 final user= ref.watch(userProvider)!;
  final isGuest =!user.isAuthenticated;
    if(!isGuest)
    {
    return ref.watch(userCommunitiesProvider).when(data: (communities)=>
    
    ref.watch(userPostsProvider(communities)).when(data: (data){
        return ListView.builder(
          
          itemCount: data.length,
          itemBuilder: (BuildContext context , int index){
            final post = data[index];
            return PostCard(post: post);

        });


    },  error: (error,StackTrace){
      if (kDebugMode)print(error);
      return ErrorText(error: error.toString());
  }, loading:()=> const Loader(),)
    ,
    
    
    error: (error,StackTrace)=>ErrorText(error:error.toString()), 
    
    loading: ()=> const Loader());
  }
  

  return ref.watch(userCommunitiesProvider).when(data: (communities)=>
    
    ref.watch(guestPostsProvider).when(data: (data){
        return ListView.builder(
          
          itemCount: data.length,
          itemBuilder: (BuildContext context , int index){
            final post = data[index];
            return PostCard(post: post);

        });


    },  error: (error,StackTrace){
      if (kDebugMode)print(error);
      return ErrorText(error: error.toString());
  }, loading:()=> const Loader(),)
    ,
    
    
    error: (error,StackTrace)=>ErrorText(error:error.toString()), 
    
    loading: ()=> const Loader());
  }
  
}
