import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
    required this.writer,
    required this.likes,
    required this.dislikes,
    required this.image,
    required this.imageNum,
    required this.regDate,
    required this.modDate,
  });

  late String id;
  late String uid;
  late String title;
  late String content;
  late String writer;
  late int likes;
  late int dislikes;
  late bool image;
  late int imageNum;
  late Timestamp regDate;
  late Timestamp modDate;

  Post.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = data['id'];
    uid = data['uid'];
    title = data['title'];
    content = data['content'];
    writer = data['writer'];
    likes = data['likes'];
    dislikes = data['dislikes'];
    image = data['image'];
    imageNum = data['imageNum'];
    regDate = data['regDate'];
    modDate = data['modDate'];
  }
}
