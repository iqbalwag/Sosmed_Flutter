import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Color bottonNavBgColor = Color.fromARGB(255, 46, 51, 65);

class CommentPage extends StatefulWidget {
  // final Function()? onTap;
  final String title;
  final String userEmail;
  final String image;
  final String postId;
  final List<String> likes;
  const CommentPage(
      {super.key,
      required this.postId,
      required this.title,
      required this.userEmail,
      required this.image,
      required this.likes});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController textController = TextEditingController();
  bool isLiked = false;
  bool isPressed = false;
  List coba = [];
// bool _emojiShowing = false;

// final key = GlobalKey<EmojiPickerState>();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }

    postRef.get();
  }

  @override
  Widget build(BuildContext context) {
    const avatar = "images/2b.jpg";
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(300),
            child: SizedBox(
              height: 0,
            )),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          "Comments",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              )),
        ],
        // toolbarHeight: 300,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemStatusBarContrastEnforced: false),
        flexibleSpace: FlexibleSpaceBar(
          background: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft:
                  Radius.circular(20.0), // Atur sudut radius sesuai kebutuhan
              bottomRight: Radius.circular(20.0),
            ),
            child: Image.network(
              widget.image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: _firestore
              .collection('User Posts')
              .doc(widget.postId)
              .collection('Comments')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //final comments = _firestore.collection('User Posts').doc(widget.postId).collection('Comments');
              final docs = snapshot.data!.docs;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 210,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: isLiked == false
                              ? const FaIcon(FontAwesomeIcons.heart)
                              : const FaIcon(FontAwesomeIcons.solidHeart),
                          onTap: () {
                            toggleLike();
                          },
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget.likes.length.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          child: const FaIcon(FontAwesomeIcons.comment),
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(docs.length.toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.w400)),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 23,
                            child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  widget.userEmail,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ))),
                      ],
                    ),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final comments = docs[index].data();
                          return Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 27,
                                backgroundImage: NetworkImage(
                                    "https://avatar.iran.liara.run/public/$index"),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                    255, 43, 43, 43)
                                                .withOpacity(0.3))),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 4, right: 16),
                                    title: Text(
                                      comments['User'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      comments['Comment'],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: const FaIcon(
                                          CupertinoIcons.heart,
                                          color: Colors.pink,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error : ${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 56, //In Future remove the height
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: bottonNavBgColor.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: bottonNavBgColor.withOpacity(0.3),
                offset: const Offset(0, 20),
                blurRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(avatar),
                ),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    controller: textController,
                    // onTap: () {
                    //   setState(() {
                    //     textController.text;
                    //   });
                    // },
                    onChanged: (value) {
                      setState(() {
                        textController.text;
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      hintText: 'Add Comment...',
                    ),
                  ),
                ),
                textController.text.isEmpty
                    ? const Icon(
                        Icons.emoji_emotions,
                        color: Colors.white,
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _firestore
                              .collection("User Posts")
                              .doc(widget.postId)
                              .collection('Comments')
                              .add({
                            "User": currentUser.email,
                            "Comment": textController.text,
                            "TimeStamp": Timestamp.now(),
                          });

                          textController.clear();
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
