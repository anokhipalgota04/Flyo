import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/common/loader.dart';
import 'package:flutter_application_1/core/constants/constants.dart';
import 'package:flutter_application_1/core/providers/firebase_providers.dart';
import 'package:flutter_application_1/core/common/sign_in_button.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInAsGuest(WidgetRef ref, BuildContext context){
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    final isLoading=ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Trip Saathi',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'Chalo Gumne',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
             signInAsGuest(ref,context);
            },
            child: Text('Skip'),
          )
        ],
        titleSpacing: 0,
      ),
      body: isLoading?const Loader() :Stack(
        
        
          children: [
                Image.asset(
                  Constants.logoimage,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width, // Set width to screen width
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20, // Adjust the position as needed
                  child: Center(
                    child: SigninButton(),
                  ),
                ),
              ],
        
      ),
    );
  }
}

