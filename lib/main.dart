import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:front_sosmed/auth/login_or_register.dart';
import 'package:front_sosmed/pages/comment_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
      fontFamily: 'MPLUSRounded1c',
    );
    return MaterialApp(
      theme: ThemeData(textTheme: newTextTheme),
      home: const LoginOrRegister(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;
  final imagePicker = ImagePicker();
  ScrollController _scrollViewController = ScrollController();
  bool _showAppbar = true; 
  bool isScrollingDown = false;
  var faker = Faker();
  bool isLiked = false;
  // final cu = FirebaseAuth;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    const avatar = "images/2b.jpg";
    return Scaffold(
      // body: NestedScrollView(
      //   headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
      //     return <Widget> [
      //       SliverAppBar(
      //         title: const Text('Weight Tracker'),
      //         pinned: true,
      //         floating: true,
      //         forceElevated: innerBoxIsScrolled,
      //       ),
      //     ];
      //   },
        body: SafeArea(
          child: Column(
            children: [
              AnimatedContainer(
                height: _showAppbar ? 56.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: AppBar(
                  surfaceTintColor: Colors.white,
                  title: const Text("Popo",style: TextStyle(fontWeight: FontWeight.bold),),
                  actions: const [
                    Icon(Icons.notifications_active_rounded),
                    SizedBox(width: 20,),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  controller: _scrollViewController,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            Container(
                              height: 100,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  10,
                                  (int index) {
                                    if (index == 0){
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showPictureDialog();
                                            },
                                            child: Stack(
                                              children: [
                                                // CircleAvatar(
                                                
                                                // child: imageFile != null
                                                // ? Image.file(File(imageFile!.path)):Image.asset(avatar)
                                                // ),
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  margin: const EdgeInsets.all(10),
                                                  child: imageFile != null
                                                  ? Image.file(File(imageFile!.path))
                                                  :
                                                  const CircleAvatar(backgroundImage: AssetImage(avatar),)
                                                ),
                                                Positioned(
                                                  bottom: 5,
                                                  right: 5,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.blue, shape: BoxShape.circle),
                                                    child: const Text(
                                                      "+",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                          ),
                                            const Text(
                                              "Your Story",
                                              style: TextStyle(color: Colors.black, fontSize: 13),
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
                                              style: const TextStyle(color: Colors.black, fontSize: 13),
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
                            List.generate(
                              10,
                              (int index) {
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://avatar.iran.liara.run/public/$index"),
                                      ),
                                      title: Text(
                                        faker.internet.userName(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 10),
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  offset: const Offset(0, 3),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            height: 220,
                                            child: Image.network(
                                              "https://picsum.photos/id/${10+index}/300/200",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(
                                                width: 210,
                                                child: Text("Night Watch", 
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                child: isLiked == false ? const FaIcon(FontAwesomeIcons.heart) : const FaIcon(FontAwesomeIcons.solidHeart),
                                                onTap: () {
                                                  toggleLike();
                                                },
                                              ),
                                              const SizedBox(width: 2,),
                                              const Text('152',style: TextStyle(fontWeight: FontWeight.w200,fontSize: 13),),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                child: const FaIcon(FontAwesomeIcons.comment),
                                                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const CommentPage(),));},
                                              ),
                                              const SizedBox(width: 2,),
                                              const Text('15',style: TextStyle(fontWeight: FontWeight.w200)),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                          const Row(
                                            children: [
                                              SizedBox(height: 30, child: Text("alo", textAlign: TextAlign.left,)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
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
                    setState(() {
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border_outlined),
                  onPressed: () {
                    setState(() {
                    });
                  },
                ),
                IconButton(
                  icon: const CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                  ),
                  onPressed: () {
                    setState(() {
                    });
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
          onPressed: () {},
          child: const Icon(Icons.add,color: Colors.white,),
        ),
    );
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
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
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