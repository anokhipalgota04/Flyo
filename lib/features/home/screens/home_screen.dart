import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/constants.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/home/screens/deligates/search_community_Deligate.dart';
import 'package:flutter_application_1/features/home/screens/drawers/communitylist_drawer.dart';
import 'package:flutter_application_1/features/home/screens/drawers/profile_drawer.dart';
import 'package:flutter_application_1/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
   @override
  ConsumerState<ConsumerStatefulWidget> createState() =>_HomeScreenState();
}

  class _HomeScreenState extends ConsumerState<HomeScreen>{

  int _page=0;

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page){
    setState(() {
      _page=page;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvider)!;
   final  currenttheme =ref.watch(themeNotifierProvider);
   final isGuest =!user.isAuthenticated;
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(onPressed: ()=>displayDrawer(context), icon: Icon(Icons.menu));
          }
        ),
        actions: [
          
          IconButton(onPressed: (){

            showSearch(context: context, delegate: SearchCommunityDelegate(ref));
          }, icon: Icon(Icons.search)),
        Builder(
          builder: (context) {
            return InkWell(onTap: ()=>displayEndDrawer(context),
              
              child: Padding(
                padding: const EdgeInsets.only(left: 8,right: 12),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                  radius: 15,
                ),
              ),
            );
          }
        )
        
        ],

      ),
      body:Constants.tabWidgets[_page],
      drawer:const CommunityListDrawer() ,
      endDrawer: isGuest ? null :const ProfileDrawer(),
      bottomNavigationBar:isGuest ? null :CupertinoTabBar(
        activeColor:currenttheme.iconTheme.color ,
        backgroundColor: currenttheme.colorScheme.background,
        items: const[
        BottomNavigationBarItem(
          icon:Icon(Icons.home), label: 'Home' ),
           BottomNavigationBarItem(
          icon:Icon(Icons.add), label: 'Add' ),
          //  BottomNavigationBarItem(
          // icon:Icon(Icons.people), label: 'People' ),
          //  BottomNavigationBarItem(
          // icon:Icon(Icons.home), label: 'Home' ),



      ],
      onTap:   onPageChange,
      currentIndex: _page,
      
      ) ,
     // body: Center(child: Text(user.name)),
      
      );
  }
  
 
}

