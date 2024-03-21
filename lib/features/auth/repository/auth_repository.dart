

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/firebase_constants.dart';
import 'package:flutter_application_1/core/failure.dart';
import 'package:flutter_application_1/core/providers/firebase_providers.dart';
import 'package:flutter_application_1/core/type_Defs.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_1/core/constants/constants.dart';
final authRepositoryProvider=
Provider((ref) => AuthRepository(firestore: ref.read(firestoreProvider), 
auth: ref.read(authProvider),
 googleSignIn: ref.read(GoogleSignInProvider)));

class AuthRepository{
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthRepository({
    required FirebaseFirestore firestore,
   required FirebaseAuth auth, 
   required GoogleSignIn googleSignIn })
   :_auth=auth,
   _firestore=firestore,
   _googleSignIn=googleSignIn;

   CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
   Stream<User?>get authStateChange => _auth.authStateChanges();


  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async{
    try{
      final GoogleSignInAccount? googleUser=await _googleSignIn.signIn();
      final googleAuth= (await googleUser?.authentication);
      final credential =GoogleAuthProvider.credential(

        accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken
      );
      UserCredential userCredential;
      if(isFromLogin)
      {
        userCredential =await _auth.signInWithCredential(credential);
      }
      else{
        userCredential =await _auth.currentUser!.linkWithCredential(credential);
      }

      
     //print(userCredential.user?.email);
        UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser){

 userModel =UserModel(
        name: userCredential.user!.displayName??'Untitled', 
        profilePic:userCredential.user!.photoURL?? Constants.avatarDefault,
         banner: Constants.bannerDefault, 
         isAuthenticated: true,
          uid: userCredential.user!.uid,
           karma: 0, 
           awards: ['til', 'thankyou','rocket', 
              'plusone',    'helpful','platinum','gold','awesomeAns']);
           await  _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } 
      else{
        userModel= await getUserData(userCredential.user!.uid).first;
      }  
      return right(userModel);
    }
    on FirebaseException catch(E){
throw E.message! ;}
catch (E){
   return left(Failure(E.toString()));
    }

  }


FutureEither<UserModel> signInAsGuest() async{
    try{
      var userCredential =await _auth.signInAnonymously();
      
        UserModel userModel=UserModel(
        name: 'Guest', 
        profilePic:Constants.avatarDefault,
         banner: Constants.bannerDefault, 
         isAuthenticated: false,
          uid: userCredential.user!.uid,
           karma: 0, 
           awards: [],);
           await  _users.doc(userCredential.user!.uid).set(userModel.toMap());
      
       
      return right(userModel);
    }
    on FirebaseException catch(E){
throw E.message! ;}
catch (E){
   return left(Failure(E.toString()));
    }

  }


  Stream<UserModel> getUserData(String uid){
    return _users.doc(uid).snapshots().map((event)=>UserModel.fromMap(event.data()as Map<String,dynamic>));
  }

  void LogOut()async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}