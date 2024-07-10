import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Color bottonNavBgColor = Color.fromARGB(255, 46, 51, 65);

class CommentPage extends StatefulWidget {
  // final Function()? onTap;
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool isLiked = false;
// bool _emojiShowing = false;

// final key = GlobalKey<EmojiPickerState>();

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
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
              "https://picsum.photos/id/1/300/200",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 210,
                  child: Text(
                    "Night Watch",
                    style: TextStyle(
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
                const Text(
                  '152',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  child: const FaIcon(FontAwesomeIcons.comment),
                  onTap: () {},
                ),
                const SizedBox(
                  width: 2,
                ),
                const Text('15', style: TextStyle(fontWeight: FontWeight.w400)),
                const SizedBox(width: 10),
              ],
            ),
            const Row(
              children: [
                SizedBox(
                    height: 23,
                    child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "alo",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ))),
              ],
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: 4,
                itemBuilder: (context, index) {
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
                                    color: const Color.fromARGB(255, 43, 43, 43)
                                        .withOpacity(0.3))),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 4, right: 16),
                            title: Text(
                              faker.person.firstName(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(faker.lorem.words(4).join(" ")),
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
      ),
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
          child: const Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(avatar),
              ),
              Expanded(
                child: TextField(
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    hintText: 'Add Comment...',
                  ),
                ),
              ),
              Icon(
                Icons.emoji_emotions,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
