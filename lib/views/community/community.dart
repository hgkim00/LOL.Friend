import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/services/community_service.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    final communityService = Provider.of<CommunityService>(context);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color(0xFF020F1C),
          title: const Text('LOL COMMUNITY'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: FutureBuilder(
              future: communityService.getPosts(),
              builder: ((context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshots.connectionState == ConnectionState.done) {
                  if (communityService.posts.isEmpty) {
                    return const Center(child: Text('등록된 게시글이 없습니다.'));
                  } else {
                    DateTime current = DateTime.now();
                    String time = '';
                    return ListView.builder(
                      itemCount: communityService.posts.length,
                      itemBuilder: (context, index) {
                        DateTime post =
                            communityService.posts[index].regDate.toDate();

                        Duration difference = current.difference(post);

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
                        String user = communityService.posts[index].writer;
                        return Column(
                          children: [
                            ListTile(
                              visualDensity: VisualDensity.compact,
                              leading: Column(
                                children: [
                                  const Icon(CupertinoIcons.hand_thumbsup_fill),
                                  Text(
                                      "${communityService.posts[index].likes}"),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: communityService.posts[index]);
                              },
                              title: Text(
                                communityService.posts[index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text("$time  |  $user"),
                              trailing: LayoutBuilder(
                                  builder: (context, constraints) {
                                return SizedBox(
                                  width: 57,
                                  height: 57,
                                  child: communityService.posts[index].image
                                      ? FutureBuilder(
                                          future: communityService
                                              .getThumbnailURL(communityService
                                                  .posts[index].id),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot
                                                        .connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.hasData) {
                                              String imageURL = snapshot.data!;
                                              return Image.network(
                                                imageURL,
                                              );
                                            } else {
                                              return Text(
                                                  "Error: ${snapshot.error}");
                                            }
                                          })
                                      : const Text(''),
                                );
                              }),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  return const Center(child: Text('데이터 로드 중 에러가 발생했습니다.'));
                }
              }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addpost');
          },
          child: const Icon(CupertinoIcons.pencil),
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
