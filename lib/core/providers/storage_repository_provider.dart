// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_application_1/core/failure.dart';
// import 'package:flutter_application_1/core/type_Defs.dart';
// import 'package:fpdart/fpdart.dart';

// class StorageRepository{

//   final FirebaseStorage _firebaseStorage;
//  StorageRepository({required FirebaseStorage firebaseStorage})
//  :_firebaseStorage=firebaseStorage;

//  FutureEither<String> storeFile()async{
//   try{
//     _firebaseStorage.ref().child(path).child(path);

//   }catch(e)
//   {
//     return left(Failure(e.toString()));
//   }
//    }
// }
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/core/failure.dart';
import 'package:flutter_application_1/core/providers/firebase_providers.dart';
import 'package:flutter_application_1/core/type_Defs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';


final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage}) : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
    // required Uint8List? webFile,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask =ref.putFile(file!); 

      // if (kIsWeb) {
      //   uploadTask = ref.putData(webFile!);
      // } else {
      //   uploadTask = ref.putFile(file!);
      // }

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}