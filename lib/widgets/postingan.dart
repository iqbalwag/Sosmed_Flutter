import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/comment_page.dart';

class FeedWidget extends StatelessWidget {
  final int index;
  final bool isLiked;
  final Function? toggleLike;
  const FeedWidget({super.key, required this.index, required this.isLiked, required this.toggleLike});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://avatar.iran.liara.run/public/$index"),
          ),
          title: Text(
            faker.person.firstName(),
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
                      toggleLike!();
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
  }
}