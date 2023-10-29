import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol_friend/models/post.dart';
import 'package:lol_friend/services/community_service.dart';
import 'package:lol_friend/views/app.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  const EditPost({Key? key, required this.existPost}) : super(key: key);
  final Post existPost;

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late Post post;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    post = widget.existPost;
  }

  final List<File> _pickedImages = [];
  final picker = ImagePicker();

  String content = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final communityService = Provider.of<CommunityService>(context);
    List<String> imagesURL = [];
    final title = TextEditingController(text: post.title);
    final content = TextEditingController(text: post.content);

    Future<void> getImage() async {
      _pickedImages.clear();
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        setState(() {
          for (var image in picked) {
            _pickedImages.add(File(image.path));
          }
        });
      } else {
        print('No Image Selected..');
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'LOLPOST',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                await communityService.editPost(post.id, title.text,
                    content.text, _pickedImages, post.imageNum);
                Timer(
                    const Duration(seconds: 1),
                    () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const App()),
                        (route) => false));
              },
              child: const Text(
                'EDIT',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: title,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: '제목을 입력해주세요',
                        filled: true,
                        border: InputBorder.none,
                        fillColor: Color(0xFF9E9E9E),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 13, 8, 8),
                      child: Text(
                        'Content',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: TextFormField(
                        controller: content,
                        keyboardType: TextInputType.multiline,
                        minLines: 8,
                        maxLines: 12,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: '내용을 입력해주세요',
                          filled: true,
                          fillColor: Color(0xFF9E9E9E),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    _pickedImages.isNotEmpty || post.image
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                            child: Text(
                              'Selected Images',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : const SizedBox(height: 20),
                    post.image && _pickedImages.isEmpty
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

                                return CarouselSlider(
                                    options: CarouselOptions(
                                      height: height * 0.2,
                                      viewportFraction: 0.5,
                                      scrollDirection:
                                          Axis.horizontal, // 슬라이더 스크롤 방향 설정
                                      enableInfiniteScroll: false,
                                    ),
                                    items:
                                        List.generate(post.imageNum, (index) {
                                      return Builder(
                                          builder: (BuildContext context) {
                                        return SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child:
                                              Image.network(imagesURL[index]),
                                        );
                                      });
                                    }));
                              } else {
                                return Text("Error: ${snapshot.error}");
                              }
                            })
                        : const SizedBox(),
                    _pickedImages.isNotEmpty
                        ? CarouselSlider(
                            options: CarouselOptions(
                              height: height * 0.2,
                              viewportFraction: 0.5,
                              scrollDirection:
                                  Axis.horizontal, // 슬라이더 스크롤 방향 설정
                              enableInfiniteScroll: false,
                            ),
                            items: _pickedImages.map((file) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child:
                                        Image.file(file, fit: BoxFit.fitHeight),
                                  );
                                },
                              );
                            }).toList(),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: 24,
              child: IconButton(
                onPressed: getImage,
                icon: const Icon(
                  CupertinoIcons.photo,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
