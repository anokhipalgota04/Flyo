import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});
void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
     double CardHeightWidth=120;
     double iconSize=60;
     final  currenttheme =ref.watch(themeNotifierProvider);
    return Row(
      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap:()=> navigateToType(context,'image'),
          child: SizedBox(
            height: CardHeightWidth,
            width: CardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
                color: currenttheme.colorScheme.background,
                elevation: 16,
                child:  Center( 
                  child: Icon(
                    Icons.image_outlined, 
                    size:iconSize ,)),
            ),
          ),
        ), GestureDetector(
            onTap:()=> navigateToType(context,'text'),
          child: SizedBox(
            height: CardHeightWidth,
            width: CardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
                color: currenttheme.colorScheme.background,
                elevation: 16,
                child:  Center( 
                  child: Icon(
                    Icons.font_download_outlined, 
                    size:iconSize ,)),
            ),
          ),
        ), GestureDetector(
           onTap:()=> navigateToType(context,'link'),
          child: SizedBox(
            height: CardHeightWidth,
            width: CardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
                color: currenttheme.colorScheme.background,
                elevation: 16,
                child:  Center( 
                  child: Icon(
                    Icons.link_outlined, 
                    size:iconSize ,)),
            ),
          ),
        ),



      ],
    );
  }
}