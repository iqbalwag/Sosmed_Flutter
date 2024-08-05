import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/comment_page.dart';

class FeedWidget extends StatefulWidget {
  final int index;
  final String nama;
  final String deskripsi;
  final String image;
  final String postId;
  final List<String> likes;
  const FeedWidget(
      {super.key,
      required this.index,
      required this.image,
      required this.nama,
      required this.deskripsi,
      required this.postId,
      required this.likes});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  bool isLiked = false;

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
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('User Posts')
            .doc(widget.postId)
            .collection('Comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final comments = snapshot.data!.docs;
            return Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://avatar.iran.liara.run/public/${widget.index}"),
                  ),
                  title: Text(
                    widget.nama,
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
                          image: DecorationImage(
                            image: NetworkImage(
                              //"https://picsum.photos/id/${10 + index}/300/200",
                              widget.image,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        height: 220,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 210,
                            child: Text(
                              widget.deskripsi,
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
                            style: const TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 13),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            child: const FaIcon(FontAwesomeIcons.comment),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentPage(
                                      postId: widget.postId,
                                      deskripsi: widget.deskripsi,
                                      image: widget.image,
                                      nama: widget.nama,
                                      likes: widget.likes,
                                    ),
                                  ));
                            },
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(comments.length.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w200)),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const Row(
                        children: [
                          SizedBox(
                              height: 30,
                              child: Text(
                                "alo",
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
