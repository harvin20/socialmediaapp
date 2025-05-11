
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialmediaapp/features/auth/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo{
final FirebaseStorage storage = FirebaseStorage.instance;



//mobile platform
@override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
  return _uploadFile(path, fileName,"profile name");
  }
//web platform
  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
   return _uploadFileBytes(fileBytes, fileName, "profile images");
  }

  /*

    HELPER METHODS - to upload files to storage

  */

// mobile platforms (file)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      // get file
      final file = File(path);

      // Creates a reference to the desired location in cloud storage
      final storageRef = storage.ref().child('$folder/$fileName');

      //  upload the file to the specified storage reference
      final uploadTask = await storageRef.putFile(file);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // error handling here
      return null;
    }
  }

// web platforms (bytes)
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      // find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putData(fileBytes);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

}
