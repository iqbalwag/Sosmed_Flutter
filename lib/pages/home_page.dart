import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front_sosmed/pages/upload_page.dart';
import 'package:front_sosmed/widgets/postingan.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'stories_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XFile> imageFileList = [];
  File? imageFile;
  final imagePicker = ImagePicker();
  ScrollController _scrollViewController = ScrollController();
  bool _showAppbar = true;
  bool isScrollingDown = false;
  var faker = Faker();
  late List<String> imageUrls = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  // final currentUser = FirebaseAuth.instance.currentUser!;
  // final gsReference = FirebaseStorage.instance
  //     .refFromURL("gs://sosmedproject-e95b1.appspot.com/2b-san.jpg");
  // final ref = FirebaseStorage.instance.ref().child('2b-san.jpg');
  // no need of the file extension, the name will do fine.

  @override
  void initState() {
    super.initState();

    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
    _loadImages();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  Future<void> _loadImages() async {
    try {
      // Referensi ke folder di Firebase Storage
      final ListResult result =
          await FirebaseStorage.instance.ref('image_post/').listAll();
      final List<String> urls = [];

      // Mendapatkan URL download untuk setiap file
      for (var ref in result.items) {
        final url = await ref.getDownloadURL();
        urls.add(url);
      }

      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const avatar = "images/2b.jpg";
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              height: _showAppbar ? 56.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: AppBar(
                surfaceTintColor: Colors.white,
                title: const Text(
                  "Popo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: const [
                  Icon(Icons.notifications_active_rounded),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                controller: _scrollViewController,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            10,
                            (int index) {
                              if (index == 0) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (imageFileList.isNotEmpty) {
                                          showStories();
                                        } else {
                                          showPictureDialog();
                                        }
                                      },
                                      child: Stack(children: [
                                        // CircleAvatar(

                                        // child: imageFile != null
                                        // ? Image.file(File(imageFile!.path)):Image.asset(avatar)
                                        // ),
                                        Container(
                                            width: 50,
                                            height: 50,
                                            margin: const EdgeInsets.all(10),
                                            child: imageFile != null
                                                ? Image.file(
                                                    File(imageFile!.path))
                                                : const CircleAvatar(
                                                    backgroundImage:
                                                        AssetImage(avatar),
                                                  )),
                                        imageFile != null
                                            ? const Text('data')
                                            : Positioned(
                                                bottom: 5,
                                                right: 5,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.blue,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: const Text(
                                                    "+",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                      ]),
                                    ),
                                    const Text(
                                      "Your Story",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    )
                                  ],
                                );
                              } else {
                                return SizedBox(
                                  width: 70,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              "https://picsum.photos/id/$index/200/300",
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        faker.internet.userName(),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 13),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const Divider(
                        height: 10,
                      )
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        const Gap(10),
                        SizedBox(
                            height: 500,
                            child: StreamBuilder(
                              stream: _firestore
                                  .collection('User Posts')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final docs = snapshot.data!.docs;
                                  print("data gambar $imageUrls");
                                  print("data snapshot ${docs.toList()}");
                                  return imageUrls.isEmpty
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : ListView.builder(
                                          itemCount: docs.length,
                                          itemBuilder: (context, index) {
                                            final post = docs[index].data();
                                            final postId = docs[index].id;
                                            print("post $post");
                                            return FeedWidget(
                                              index: index,
                                              image: post['Image'],
                                              title: post['Title'] ?? '',
                                              userEmail:
                                                  post['User Email'] ?? '',
                                              postId: postId,
                                              likes: List<String>.from(
                                                  post['Likes'] ?? []),
                                              //comments: docs.length,
                                            );
                                          },
                                        );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Error:${snapshot.error}"),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  setState(() {});
                },
              ),
              PopupMenuButton(
                // onSelected: (item) {
                //   setState(() {
                //     selectedItem = item;
                //   });
                // },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text(currentUser!.email ?? ''),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      ApalahProvider authProvider =
                          Provider.of<ApalahProvider>(context, listen: false);
                      authProvider.signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
                icon: const CircleAvatar(
                  backgroundImage: AssetImage(avatar),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const UploadPage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void showStories() {
    //Load to stories page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoriesPage(
                  stories: imageFileList,
                )));
  }

  Future<void> showPictureDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Action'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  getFromCamera();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getFromGallery();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Gallery'),
              ),
            ],
          );
        });
  }

  // get from gallery
  getFromGallery() async {
    final pickedFile = await imagePicker.pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile.isNotEmpty) {
      setState(() {
        imageFileList.addAll(pickedFile);
      });
    }
  }

  // get from camera
  getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
