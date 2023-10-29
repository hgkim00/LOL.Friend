import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/models/post.dart';
import 'package:lol_friend/services/community_service.dart';
import 'package:lol_friend/services/like_service.dart';
import 'package:lol_friend/views/app.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    final likeService = Provider.of<LikeService>(context);
    final communityService = Provider.of<CommunityService>(context);

    double height = MediaQuery.of(context).size.height;
    String time = '';
    List<String> imagesURL = [];
    DateTime current = DateTime.now();
    DateTime writeTime = post.regDate.toDate();
    Duration difference = current.difference(writeTime);

    int years = difference.inDays ~/ 365;
    int months = (difference.inDays % 365) ~/ 30;
    int days = (difference.inDays % 30);
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    if (years != 0) {
      time = "$years년 전";
    } else if (months != 0) {
      time = "$months달 전";
    } else if (days != 0) {
      time = "$days일 전";
    } else if (hours != 0) {
      time = "$hours시간 전";
    } else if (minutes != 0) {
      time = "$minutes분 전";
    } else {
      time = "방금 전";
    }

    Future showBottomNotification(BuildContext context) {
      return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: communityService.isOwnPost(post.uid)
              ? [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/edit", arguments: post);
                    },
                    child: const Text("포스트 수정"),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      communityService.deletePost(
                          post.id, post.image, post.imageNum);

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const App()),
                          (route) => false);
                    },
                    child: const Text("포스트 삭제"),
                  ),
                ]
              : [
                  CupertinoActionSheetAction(
                    onPressed: () {},
                    child: const Text("업데이트 예정"),
                  ),
                ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("취소"),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LOL POST"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showBottomNotification(context);
                },
                icon: const Icon(CupertinoIcons.ellipsis_vertical)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                Text(
                  "$time  |  ${post.writer}",
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 30),
                post.image
                    ? FutureBuilder(
                        future: communityService.getImagesURL(
                            post.id, post.imageNum),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            imagesURL = snapshot.data!;
                            List<Widget> images = [];
                            for (int i = 0; i < post.imageNum; i++) {
                              images.add(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    imagesURL[i],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                            return Column(children: images);
                          } else {
                            return Text("Error: ${snapshot.error}");
                          }
                        })
                    : const SizedBox(),
                Text(
                  post.content,
                  style: const TextStyle(fontSize: 16),
                ),
                post.image
                    ? const SizedBox(height: 20)
                    : post.content.length < 70
                        ? SizedBox(height: height * 0.2)
                        : post.content.length < 100
                            ? SizedBox(height: height * 0.1)
                            : const SizedBox(),
                const Divider(height: 10),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        likeService.likeItem(context, post);
                      },
                      icon: const Icon(
                        CupertinoIcons.hand_thumbsup_fill,
                        color: Colors.blue,
                      ),
                    ),
                    Text("${post.likes}"),
                    const SizedBox(width: 70),
                    IconButton(
                      onPressed: () {
                        likeService.dislikeItem(context, post);
                      },
                      icon: const Icon(
                        CupertinoIcons.hand_thumbsdown_fill,
                        color: Colors.red,
                      ),
                    ),
                    Text("${post.dislikes}"),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 10),
                // TODO: 댓글 기능 업데이트
                Container(
                  height: height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF1B2023),
                  child: const Center(child: Text("To Be Continued..")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
