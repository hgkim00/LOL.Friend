import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lol_friend/models/post.dart';
import 'package:lol_friend/services/community_service.dart';

FToast fToast = FToast();

class LikeService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final communityService = CommunityService();

  final Map<String, Set<String>> _likesData = {};

  Map<String, Set<String>> get likesData => _likesData;

  void likeItem(BuildContext context, Post post) {
    fToast.init(context);
    if (!_likesData.containsKey(post.id)) {
      _likesData[post.id] = {post.uid};
      post.likes += 1;
      _firestore.collection('post').doc(post.id).update({
        'likes': post.likes,
      });
      _showToast(
          "좋아요를 누르셨습니다!", CupertinoIcons.hand_thumbsup_fill, Colors.blue);
    } else {
      if (_likesData[post.id]!.contains(post.uid)) {
        // User has already liked this item
        _showToast("이미 누르셨습니다!", CupertinoIcons.xmark_circle, Colors.grey);
      } else {
        post.likes += 1;
        _firestore.collection('post').doc(post.id).update({
          'likes': post.likes,
        });

        _showToast(
            "좋아요를 누르셨습니다!", CupertinoIcons.hand_thumbsup_fill, Colors.blue);
      }
    }

    notifyListeners();
  }

  void dislikeItem(BuildContext context, Post post) {
    fToast.init(context);
    if (!_likesData.containsKey(post.id)) {
      _likesData[post.id] = {post.uid};
      post.dislikes += 1;
      _firestore.collection('post').doc(post.id).update({
        'dislikes': post.dislikes,
      });

      _showToast(
          "싫어요를 누르셨습니다!", CupertinoIcons.hand_thumbsdown_fill, Colors.red);
    } else {
      if (_likesData[post.id]!.contains(post.uid)) {
        // User has already liked this item
        _showToast("이미 누르셨습니다!", CupertinoIcons.xmark_circle, Colors.grey);
      } else {
        post.dislikes += 1;
        _firestore.collection('post').doc(post.id).update({
          'dislikes': post.dislikes,
        });

        _showToast(
            "싫어요를 누르셨습니다!", CupertinoIcons.hand_thumbsdown_fill, Colors.red);
      }
    }
    notifyListeners();
  }
}

void _showToast(String msg, IconData icon, Color backgroundColor) {
  Widget toast = Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 24.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: backgroundColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(
          width: 20.0,
        ),
        Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: const Duration(seconds: 1),
    gravity: ToastGravity.CENTER,
  );
}
