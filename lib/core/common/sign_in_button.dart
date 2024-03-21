import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/constants.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class SigninButton extends ConsumerWidget {
  final bool isFromLogin;
  const SigninButton({super.key ,  this.isFromLogin = true});




void signInWithGoogle(BuildContext context ,WidgetRef ref){
  ref.read(authControllerProvider.notifier).signInWithGoogle(context, isFromLogin);
  
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(onPressed: ()=>signInWithGoogle(context,ref),
       icon: Image.asset(Constants.google,width: 35,),
       label: Text('SignUp with google',style: TextStyle(fontSize: 18),),
       style:ElevatedButton.styleFrom(
        backgroundColor: Pallete.whiteColor,
        minimumSize:  Size(double.infinity, 50)
       )
       
       
       ),
    );
  }
}