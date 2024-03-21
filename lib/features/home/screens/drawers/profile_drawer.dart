import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void LogOut(WidgetRef ref){
    ref.read(authControllerProvider.notifier).logout();
  }
  void navigateToUserProfile(BuildContext context , String uid)
  {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref)
  {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =ref.watch(userProvider)!;
    return Drawer(

      child: SafeArea(child: Column(

        children: [


          CircleAvatar(

            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(height: 10,),
          Text('u/${user.name}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),),
           const SizedBox(height: 10,),
           const Divider(),
           ListTile(
          title: const Text("My Profile"),
          leading:const Icon(Icons.person) ,
          onTap: () => navigateToUserProfile(context,user.uid),
        ),
        ListTile(
          title: const Text("LogOut"),
          leading:const Icon(Icons.logout , color: Colors.red,) ,
          onTap: ()=>LogOut(ref),
        ),
        Switch.adaptive(value:ref.watch(themeNotifierProvider.notifier).mode==ThemeMode.dark ,
        
         onChanged:(val)=>toggleTheme(ref))
        ],
      )),
    );
  }
}




