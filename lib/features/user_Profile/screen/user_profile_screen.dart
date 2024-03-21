

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/common/error_text.dart';
import 'package:flutter_application_1/core/common/loader.dart';
import 'package:flutter_application_1/core/common/post_card.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/community/controller/community_controller.dart';
import 'package:flutter_application_1/features/user_Profile/controller/user_profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key ,required this.uid});


  void navigateToEditUser(BuildContext context )
  {
    Routemaster.of(context).push('/edit-profile/$uid');
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final user =ref.watch(userProvider)!;
    return SafeArea(
      child: Scaffold(
      
      body: ref.watch(getUserDataProvider(uid)).
      
      when(data: (user) => 
      
      NestedScrollView(headerSliverBuilder:(context,innerBoxIsScrolled){
      return[
      
        SliverAppBar(
          floating: true,
          snap: true,
      expandedHeight:250,
      flexibleSpace:Stack(
        children: [
      Positioned.fill(child: Image.network(user.banner, fit: BoxFit.cover,)),
     
           Container(
             alignment:Alignment.bottomLeft ,
        padding: const EdgeInsets.all(20).copyWith(bottom:70 ),
             child: CircleAvatar(
                
                backgroundImage:NetworkImage(user.profilePic) ,
                radius: 45,
              ),
           ),
         
       Container(
        alignment:Alignment.bottomLeft ,
        padding: const EdgeInsets.all(20),
         child: OutlinedButton(onPressed: ()=>navigateToEditUser(context),style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 25)
              ), child:  const Text('Edit Profile'),),
       )
      
        ],
      ) ,
      
        ),
        SliverPadding(padding: const EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
          [
          
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('u/${user.name}',style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),

          
            
           


          ],),
          Padding(
            padding: const EdgeInsets.only(top: 10),
             child: Text('${user.karma} Karma')),
             SizedBox( height: 10,),
             const Divider( thickness: 2,)
        ]
        )
        ),
        
        ),
        
      ];
      
      }, body: ref.watch(getUserPostsProvider(uid)).when(data: (data){

        return ListView.builder(
          
          itemCount: data.length,
          itemBuilder: (BuildContext context , int index){
            final post = data[index];
            return PostCard(post: post);

        });
      }, error:  (error, stackTrace) {
  
        return ErrorText(error: error.toString());
      }, loading: ()=> const Loader(),),
      ),
      
      
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading:()=> const Loader(),
      )
      ),
    );
 
  }
}