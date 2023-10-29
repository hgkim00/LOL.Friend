import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lol_friend/services/community_service.dart';
import 'package:lol_friend/views/app.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final List<File> _pickedImages = [];
  final picker = ImagePicker();

  final title = TextEditingController();
  final content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final communityService = Provider.of<CommunityService>(context);

    Future<void> getImage() async {
      _pickedImages.clear();
      final picked = await picker.pickMultiImage(
          imageQuality: 50, maxWidth: 500, maxHeight: 500);
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
              onPressed: () {
                communityService.addPost(
                    title.text, content.text, _pickedImages);
                Timer(
                    const Duration(seconds: 1),
                    () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const App()),
                        (route) => false));
              },
              child: const Text(
                'POST',
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
                    _pickedImages.isNotEmpty
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
                    CarouselSlider(
                      options: CarouselOptions(
                        height: height * 0.2,
                        viewportFraction: 0.5,
                        scrollDirection: Axis.horizontal, // 슬라이더 스크롤 방향 설정
                        enableInfiniteScroll: false,
                      ),
                      items: _pickedImages.map((file) {
                        return Builder(
                          builder: (BuildContext context) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.file(file, fit: BoxFit.fitHeight),
                            );
                          },
                        );
                      }).toList(),
                    ),
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
