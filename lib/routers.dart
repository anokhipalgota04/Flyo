// loggedOut
// loggedIn

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/screens/login_screen.dart';
import 'package:flutter_application_1/features/community/screens/add_mod_screen.dart';
import 'package:flutter_application_1/features/community/screens/community_screen.dart';
import 'package:flutter_application_1/features/community/screens/create_community.dart';
import 'package:flutter_application_1/features/community/screens/edit_community_screen.dart';
import 'package:flutter_application_1/features/community/screens/mod_tools_screen.dart';
import 'package:flutter_application_1/features/home/screens/home_screen.dart';
import 'package:flutter_application_1/features/posts/screens/add_post_type_screen.dart';
import 'package:flutter_application_1/features/posts/screens/comments_screen.dart';
import 'package:flutter_application_1/features/user_Profile/screen/edit_profile_screen.dart';
import 'package:flutter_application_1/features/user_Profile/screen/user_profile_screen.dart';

import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  

     '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
           child: CommunityScreen(
            name: route.pathParameters['name']!,
         ),
       ),

        '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        ),
          ),
         '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),

         '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
          '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
        '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
        '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
            type: routeData.pathParameters['type']!,
          ),
        ),

         '/post/:postId/comments': (route) => MaterialPage(
          child: CommentsScreen(
            postId: route.pathParameters['postId']!,
          ),
        ),


});


// final loggedInRoute = RouteMap(
//   routes: {
//     '/': (_) => const MaterialPage(child: HomeScreen()),
//     '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
//     '/r/:name': (route) => MaterialPage(
//           child: CommunityScreen(
//             name: route.pathParameters['name']!,
//           ),
//         ),
//     '/mod-tools/:name': (routeData) => MaterialPage(
//           child: ModToolsScreen(
//             name: routeData.pathParameters['name']!,
//           ),
//         ),
//     '/edit-community/:name': (routeData) => MaterialPage(
//           child: EditCommunityScreen(
//             name: routeData.pathParameters['name']!,
//           ),
//         ),
//     '/add-mods/:name': (routeData) => MaterialPage(
//           child: AddModsScreen(
//             name: routeData.pathParameters['name']!,
//           ),
//         ),
//     '/u/:uid': (routeData) => MaterialPage(
//           child: UserProfileScreen(
//             uid: routeData.pathParameters['uid']!,
//           ),
//         ),
//     '/edit-profile/:uid': (routeData) => MaterialPage(
//           child: EditProfileScreen(
//             uid: routeData.pathParameters['uid']!,
//           ),
//         ),
//     '/add-post/:type': (routeData) => MaterialPage(
//           child: AddPostTypeScreen(
//             type: routeData.pathParameters['type']!,
//           ),
//         ),
//     '/post/:postId/comments': (route) => MaterialPage(
//           child: CommentsScreen(
//             postId: route.pathParameters['postId']!,
//           ),
//         ),
//     '/add-post': (routeData) => const MaterialPage(
//           child: AddPostScreen(),
//         ),
//   },
// );