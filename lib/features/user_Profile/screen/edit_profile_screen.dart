import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/common/error_text.dart';
import 'package:flutter_application_1/core/common/loader.dart';
import 'package:flutter_application_1/core/constants/constants.dart';
import 'package:flutter_application_1/core/utils.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/community/controller/community_controller.dart';
import 'package:flutter_application_1/features/user_Profile/controller/user_profile_controller.dart';
import 'package:flutter_application_1/models/community_model.dart';
import 'package:flutter_application_1/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key , required this.uid});
 
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
 }
 
 class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
 File? bannerFile;
File? profileFile;
late TextEditingController nameController;


//  Uint8List? bannerWebFile;
//   Uint8List? profileWebFile;

@override
void initState() {
    // TODO: implement initState
    super.initState();
    nameController=TextEditingController(text: ref.read(userProvider)!.name);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

void selectBannerImage()async{
final res= await pickImage();
if(res!=null)
{
  setState(() {
    bannerFile=File(res.files.first.path!);
  });

}
}
void selectProfileImage()async{
final res= await pickImage();
if(res!=null)
{
  setState(() {
    profileFile=File(res.files.first.path!);
  });

}
}

void save() {
    ref.read(userProfileControllerProvider.notifier).editprofileCommunity(bannerFile:bannerFile, 
    profileFile:profileFile, context:context,
     name:nameController.text.trim());
  }


  @override
  Widget build(BuildContext context) {
    final isLoading =ref.watch(userProfileControllerProvider);
    final  currenttheme =ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(data: (user)=>  Scaffold(
    
backgroundColor: currenttheme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [TextButton(onPressed:save , child: const Text('Save'))],

      ),
      body:isLoading? const Loader(): Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children:[GestureDetector(
                  onTap: selectBannerImage,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern:const  [10,4],
                    strokeCap: StrokeCap.round,
                    color: currenttheme.textTheme.bodyMedium!.color!,
                    child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          
                    ) ,
                    child: bannerFile!=null ? Image.file(bannerFile!): user.banner.isEmpty||
                     user.banner==Constants.bannerDefault? 
                     const Center( child: Icon(Icons.camera_alt_outlined, size: 40,),)
                     :Image.network(user.banner),
                  )
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: selectProfileImage,
                    child:profileFile!=null?CircleAvatar(
                      backgroundImage:  FileImage(profileFile!),
                      radius: 32,
                    ):CircleAvatar(
                      backgroundImage:  NetworkImage(user.profilePic),
                      radius: 32,
                    )
                    ,
                  ),
                )
              ,
          
              
                ] 
              ),
            ),
               TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Name',
                focusedBorder: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color:Colors.blue),
                ),
                border:InputBorder.none,
                contentPadding:const  EdgeInsets.all(18)

              ),
             )
        
          
          ],
        ),
      ),
    ), error: (error,StackTrace)=>ErrorText(error: error.toString()), loading: ()=>const Loader());
  }
 }