import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStore {
  static CollectionReference getCollectionReference(String path) {
    return FirebaseFirestore.instance.collection(path);
  }

  static Future<void> deleteMessage(
      // This function will delete the message from receivers db
      String senderId,
      String receiverId,
      String messageId) async {
    var refReceiver = FireStore.getCollectionReference(
        'users/$receiverId/friends/$senderId/messages');
    await refReceiver.doc(messageId).delete();
  }

  static Future<void> unsendMessage(String senderId, String receiverId,
      String messageIdOnSender, String messageIdOnReceiver) async {
    await FireStore.deleteMessage(senderId, receiverId, messageIdOnReceiver);
    await FireStore.deleteMessage(receiverId, senderId, messageIdOnSender);
  }

  static Reference getAssetRef(String ref) {
    Reference reference = FirebaseStorage.instance.ref(ref);
    return reference;
  }

  static UploadTask getUploadTask(Reference ref, dynamic file) {
    return ref.putFile(file);
  }

  static UploadTask getUploadTaskUni8List(Reference ref, Uint8List data) {
    return ref.putData(data);
  }

  static Future<String> getDownloadUrl(UploadTask task) async {
    TaskSnapshot snapshot = await task.whenComplete(() => {});
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  static Future<bool> pauseTask(UploadTask task) async {
    return await task.pause();
  }

  static Future<bool> resumeTask(UploadTask task) async {
    return await task.resume();
  }

  static Future<bool> cancelTask(UploadTask task) async {
    return await task.cancel();
  }
}
