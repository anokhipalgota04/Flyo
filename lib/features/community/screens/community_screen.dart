import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/common/error_text.dart';
import 'package:flutter_application_1/core/common/loader.dart';
import 'package:flutter_application_1/core/common/post_card.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/community/controller/community_controller.dart';
import 'package:flutter_application_1/models/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context)
  {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community ,BuildContext context)
  {
      ref.read(CommunityControllerProvider.notifier).joinCommunity(community, context);
  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =ref.watch(userProvider)!;
    final isGuest =!user.isAuthenticated;
    return SafeArea(
      child: Scaffold(
      
      body: ref.watch(getCommunityByNameProvider(name)).
      
      when(data: (community) => 
      
      NestedScrollView(headerSliverBuilder:(context,innerBoxIsScrolled){
      return[
      
        SliverAppBar(
          floating: true,
          snap: true,
      expandedHeight:150,
      flexibleSpace:Stack(
        children: [
      Positioned.fill(child: Image.network(community.banner, fit: BoxFit.cover,))
      
        ],
      ) ,
      
        ),
        SliverPadding(padding: const EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
          [
          Align(
            alignment: Alignment.topLeft,
            child: CircleAvatar(
              
              backgroundImage:NetworkImage(community.avator) ,
              radius: 35,
            ),
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('r/${community.name}',style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),



          if(!isGuest)
            community.mods.contains(user.uid)?
            OutlinedButton(onPressed: (){

              navigateToModTools(context);
            },style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 25)

            ), child: const Text('Mod Tools')):
            
            OutlinedButton(onPressed: ()=> joinCommunity(ref, community, context),style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 25)
            ), child:  Text(community.members.contains(user.uid)?'I am your Saathi ':'Be a TripSaathi'),)


          ],),
          Padding(
            padding: const EdgeInsets.only(top: 10),
             child: Text('${community.members.length} members'))
        ]
        )
        ),
        
        ),
        
      ];
      
      }, body: ref.watch(getCommunityPostsProvider(name)).when(data: (data){

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
      )
    );
  }
}