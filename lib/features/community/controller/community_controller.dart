import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/constants.dart';
import 'package:flutter_application_1/core/failure.dart';
import 'package:flutter_application_1/core/providers/storage_repository_provider.dart';
import 'package:flutter_application_1/core/utils.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/community/repository/community_repository.dart';
import 'package:flutter_application_1/models/community_model.dart';
import 'package:flutter_application_1/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider =StreamProvider((ref){
final CommunityController =ref.watch(CommunityControllerProvider.notifier);
return CommunityController.getUserCommunities();

},
);

// final userCommunitiesProvider = FutureProvider<List<Community>>((ref) async {
//   final communityController = ref.watch(CommunityControllerProvider.notifier);
//   try {
//     // Fetch user communities
//     final communities = await communityController.getUserCommunities().first;
//     return communities;
//   } catch (error) {
//     // Handle error here
//     print('Error fetching user communities: $error');
//     // Return an empty list or throw the error
//     return []; // You can return any default value here
//   }
// });


final CommunityControllerProvider =StateNotifierProvider<CommunityController,bool>((ref){
  final communityRepository =ref.watch(CommunityRepositoryProvider);
   final storageRepository = ref.watch(storageRepositoryProvider);
return CommunityController(
  communityRepository: communityRepository,
   storageRepository: storageRepository,
   ref: ref);

},
);

final getCommunityByNameProvider = StreamProvider.family((ref,String name) {
 
  return ref.watch(CommunityControllerProvider.notifier).getCommunityByName(name);
});

final searchCommunityProvider =StreamProvider.family((ref, String query){
return ref.watch(CommunityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(CommunityControllerProvider.notifier).getCommunityPosts(name);
});

class CommunityController extends StateNotifier<bool>{
  final CommunityRepository _communityRepository;
  final Ref _ref;
   final StorageRepository _storageRepository;
  CommunityController({
     required CommunityRepository communityRepository,
   required Ref ref, 
    required StorageRepository storageRepository,}):
   _communityRepository=communityRepository,
   _ref=ref,  _storageRepository = storageRepository,super(false);

void createCommunity(String name ,BuildContext context)async{
  state= true;
final uid= _ref.read(userProvider)?.uid ??'';
  Community community=Community(
    id: name,
   name: name, 
   banner: Constants.bannerDefault, 
   avator: Constants.avatarDefault,
    members: [uid], 
    mods: [uid]);

    final res= await _communityRepository.createCommunity(community) ;
    state=false;
    res.fold((l) => showSnackBar(context,l.message), (r) {
      showSnackBar(context,'Community Created Successfully');
      Routemaster.of(context).pop();
    });
}

Stream<List<Community>> getUserCommunities(){
  final uid =  _ref.read(userProvider)!.uid;
  return _communityRepository.getUserCommunities(uid);
}
  
Stream<Community> getCommunityByName(String name)
{
  return _communityRepository.getCommunityByName(name);
}


 void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    // required Uint8List? profileWebFile,
    // required Uint8List? bannerWebFile,
    required BuildContext context,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null )
    // || profileWebFile != null) 
    {
      // communities/profile/communityname
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile, 
        // webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avator: r),
      );
    }

    if (bannerFile != null )
    // || bannerWebFile != null)
      {
      // communities/banner/name
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile, 
        // webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }


  void joinCommunity(Community community , BuildContext context)async{
    final user =_ref.read(userProvider)!;
    Either<Failure, void> res;
    if(community.members.contains(user.uid))
    {
        res=await  _communityRepository.LeaveCommunity(community.name, user.uid);
    }
  else
  {
    res= await _communityRepository.joinCommunity(community.name, user.uid);
  }

  res.fold((l) => showSnackBar(context,l.message), (r) => {

     if(community.members.contains(user.uid)){
      showSnackBar(context,'Community Left Successfully')
     }
     else
     {
        showSnackBar(context,'Community Joined Successfully')
     }
  });
  }

  Stream<List<Community >> searchCommunity (String query)
  {
      return _communityRepository.searchCommunity(
        query
      );

  }
 void addMods(String communityName, List<String> uids, BuildContext context)async {

 final res = await  _communityRepository.addMods(communityName, uids);
 res.fold(
  (l) => showSnackBar(context,l.message),
  (r) =>Routemaster.of(context).pop() );

 }

 
  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }

}




  
  