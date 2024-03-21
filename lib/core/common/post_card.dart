import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/common/error_text.dart';
import 'package:flutter_application_1/core/common/loader.dart';
import 'package:flutter_application_1/core/constants/constants.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/community/controller/community_controller.dart';
import 'package:flutter_application_1/features/posts/controller/post_controller.dart';
import 'package:flutter_application_1/models/post_model.dart';
import 'package:flutter_application_1/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key ,  required this.post});


   void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

   void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref.read(postControllerProvider.notifier).awardPost(post: post, award: award, context: context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage=post.type=='image';
    final isTypeText=post.type=='text';
    final isTypeLink=post.type=='link';
   final  currenttheme =ref.watch(themeNotifierProvider);
   final user= ref.watch(userProvider)!;
   final isGuest =!user.isAuthenticated;
    return Column(

      children: [

Container(
  decoration: BoxDecoration(

    color: currenttheme.colorScheme.background,
  ),
  padding: EdgeInsets.symmetric(vertical: 10),

  child: Row(

    children: [


      Expanded(
        child: Column(
          children: [

            Container(

              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 16).copyWith(right:0 ),

              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                
                
                Row(
                   mainAxisAlignment:MainAxisAlignment.spaceBetween ,

                  children: [
                    Row(
                   
                    
                    children: [ 
                    
                      GestureDetector(
                        onTap:()=> navigateToCommunity(context),
                        child: CircleAvatar(
                                            
                          backgroundImage: NetworkImage(post.communityProfilePic),
                          radius: 16,
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment:CrossAxisAlignment.start ,
                        children: [
                          Text('ts/${post.communityName}',style: TextStyle(
                    
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                          
                          ,GestureDetector(
                            onTap: ()=> navigateToUser(context),
                            child: Text('u/${post.username}',style: TextStyle(
                                                
                              fontSize: 12,
                            
                            ),),
                          ),
                    
                    
                        ],
                      ),
                      
                      ),
                    
                      
                      
                    ],
                    ),
                                   if(post.uid== user.uid)
                                  IconButton(onPressed:(){deletePost(ref,context);} , icon: Icon(Icons.delete, color: Pallete.redColor,))
                  ],
                ),
                  if(post.awards.isNotEmpty)...[
                  const SizedBox(height: 5,),
                  SizedBox(height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post.awards.length,
                    itemBuilder: (BuildContext context, int index){
                        final award =post.awards[index];
                      return Image.asset(Constants.awards[award]!, height:23 ,);
                    }),
                  )

                  ],

                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Text(post.title,style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                ),

                if(isTypeImage)
                SizedBox(height: MediaQuery.of(context).size.height*0.25,
                
                width: double.infinity,
                child: Image.network(post.link!,
                fit:BoxFit.cover
                ),
                
                ),

                if(isTypeLink)
                SizedBox(height: MediaQuery.of(context).size.height*0.15,
                
                width: double.infinity,
                child: AnyLinkPreview(
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  link: post.link!,
                  )
                ),
                
                if(isTypeText)
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5 ),
                    child:
                    
                     Text(post.description ?? '',
                     style: const TextStyle(color: Colors.white),),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [

                        IconButton(onPressed: isGuest ?(){}: ()=>upvotePost(ref),
                         icon: Icon(Icons.thumb_up , size: 30,
                         color: post.upvotes.contains(user.uid)?Pallete.redColor:null ),
                          ),
                          Text('${post.upvotes.length-post.downvotes.length==0?
                          'Vote':post.upvotes.length-post.downvotes.length}',
                          style: TextStyle(fontSize: 17),),

                          IconButton(onPressed:isGuest ?(){}: ()=>downvotePost(ref),
                         icon: Icon(Icons.thumb_down, size: 30,
                         color: post.downvotes.contains(user.uid)?Pallete.blueColor:null ),
                          )
                      ],
                    ),



                       Row(
                      children: [

                        IconButton(onPressed: ()=>navigateToComments(context),
                         icon: Icon(Icons.comment ),
                          ),
                          Text('${post.commentCount==0?
                          'Comment':post.commentCount}',
                          style: TextStyle(fontSize: 17),),
                          

                        
                      ],
                      
                    ),
                    ref.watch(getCommunityByNameProvider(post.communityName)).when(data: (data){
                      if(data.mods.contains(user.uid))
                      {
                        return  IconButton(onPressed: ()=>deletePost(ref, context),
                         icon: Icon(Icons.admin_panel_settings ),
                          );
                      }
                    return SizedBox();

                    
                   
                    },
                    
                    error: ((error, stackTrace) => ErrorText(error: error.toString())) ,loading: ()=>Loader())
                     

                   ,


              IconButton(onPressed:isGuest ?(){}: (){

                showDialog(context: context,
                
                 builder: (context)=>
                  Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                       SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                         itemCount:user.awards.length ,
                          itemBuilder: (BuildContext context, int index){
                            final award =user.awards[index];
                            return GestureDetector(
                              onTap:()=>awardPost(ref, award, context) ,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(Constants.awards[award]!),
                              ),
                            );
                          },
                         
                      
                      
                        ),
                    ),
                  )
                  );


                 }, icon: Icon(Icons.card_giftcard_outlined,),
                 
                 ),
                  ],
                )
                ,
                Divider(thickness: 3,)
                

             
              ]
              ),
            )


          ],
        ),
      )
    ],
  ),
)

      ],
    );
  }
}