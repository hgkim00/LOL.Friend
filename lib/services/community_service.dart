import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lol_friend/models/post.dart';

class CommunityService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  List<Post> posts = [];

  Future<void> getPosts() async {
    final postsReference = _firestore
        .collection('post')
        .orderBy('regDate', descending: true)
        .get();
    posts = await postsReference.then((QuerySnapshot results) {
      return results.docs.map((DocumentSnapshot document) {
        return Post.fromSnapShot(document);
      }).toList();
    });
  }

  Future<void> addPost(String title, String content, List<File> images) async {
    final docID = _firestore.collection('post').doc().id;
    String nickName = '';

    await _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      nickName = data['nick'];
    });
    _firestore.collection('post').doc(docID).set({
      'id': docID,
      'uid': _auth.currentUser!.uid,
      'title': title,
      'content': content,
      'writer': nickName != "" ? nickName : "Guest",
      'likes': 0,
      'dislikes': 0,
      'image': images.isNotEmpty ? true : false,
      'imageNum': images.length,
      'regDate': FieldValue.serverTimestamp(),
      'modDate': FieldValue.serverTimestamp(),
    });

    if (images.isNotEmpty) {
      uploadImage(images, docID);
    }

    notifyListeners();
  }

  Future<void> editPost(String docId, String title, String content,
      List<File> images, int currImgNum) async {
    if (images.isNotEmpty) {
      _firestore.collection('post').doc(docId).update({
        'title': title,
        'content': content,
        'image': true,
        'imageNum': images.length,
        'modDate': FieldValue.serverTimestamp(),
      });
      for (int i = 0; i < currImgNum; i++) {
        final imageRef = _storage.ref().child("images/$docId$i");
        await imageRef.delete();
      }
      uploadImage(images, docId);
    } else {
      _firestore.collection('product').doc(docId).update({
        'title': title,
        'content': content,
        'modDate': FieldValue.serverTimestamp(),
      });
    }
    notifyListeners();
  }

  Future<void> deletePost(String docId, bool image, int imageNum) async {
    _firestore.collection('post').doc(docId).delete();
    if (image) {
      for (int i = 0; i < imageNum; i++) {
        final imageRef = _storage.ref().child("images/$docId$i");
        await imageRef.delete();
      }
    }
    notifyListeners();
  }

  bool isOwnPost(String postUID) {
    if (_auth.currentUser!.uid == postUID) {
      return true;
    }
    return false;
  }

  Future<String> getThumbnailURL(String postId) async {
    Reference ref = _storage.ref().child('images/${postId}0');
    String url = await ref.getDownloadURL();

    return url;
  }

  Future<List<String>> getImagesURL(String postId, int imageNum) async {
    List<String> urlList = [];
    for (int i = 0; i < imageNum; i++) {
      Reference ref = _storage.ref().child('images/$postId$i');
      urlList.add(await ref.getDownloadURL());
    }

    return urlList;
  }

  Future<void> uploadImage(List<File> images, String docID) async {
    int num = 0;
    for (var image in images) {
      await _storage.ref("images/$docID$num").putFile(image);
      num += 1;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    print("Upload Success!");
  }
}
