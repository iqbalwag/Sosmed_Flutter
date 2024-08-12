import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/stories_progressbar.dart';

class StoriesPage extends StatefulWidget {
  final List<XFile> stories;
  const StoriesPage({super.key, required this.stories});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  int currentStoryIndex = 0;

  List<double> percentValue = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.stories.length; i++) {
      percentValue.add(0);
    }

    _watchStories();
  }

  void _watchStories() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (percentValue[currentStoryIndex] + 0.01 < 1) {
          percentValue[currentStoryIndex] += 0.01;
        } else {
          percentValue[currentStoryIndex] = 1;
          timer.cancel();

          if (currentStoryIndex < widget.stories.length - 1) {
            currentStoryIndex++;

            _watchStories();
          } else {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 2) {
      setState(() {
        if (currentStoryIndex > 0) {
          percentValue[currentStoryIndex - 1] = 0;
          percentValue[currentStoryIndex] = 0;

          currentStoryIndex--;
        }
      });
    } else {
      setState(() {
        if (currentStoryIndex < widget.stories.length - 1) {
          percentValue[currentStoryIndex] = 1;
          currentStoryIndex++;
        } else {
          percentValue[currentStoryIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details),
      child: Scaffold(
        body: Stack(
          children: [
            Image.file(
              File(widget.stories[currentStoryIndex].path),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            StoryProgressBar(
              percentValue: percentValue,
            )
          ],
        ),
      ),
    );
  }
}

// class StoryA extends StatelessWidget {
//   final List<XFile> stories;
//   const StoryA({
//     super.key,
//     required this.stories,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Image.file(File(stories.path)),
//     );
//   }
// }
