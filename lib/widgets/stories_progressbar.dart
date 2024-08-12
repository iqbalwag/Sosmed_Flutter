import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StoryProgressBar extends StatelessWidget {
  const StoryProgressBar({required this.percentValue, super.key});

  final List<double> percentValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 40, left: 8, right: 8),
        child: Row(
          children: List.generate(
            percentValue.length,
            (index) {
              return Expanded(
                  child: RProgressBar(percentValue: percentValue[index]));
            },
          ),
        ));
  }
}

class RProgressBar extends StatelessWidget {
  final double percentValue;

  const RProgressBar({super.key, required this.percentValue});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      barRadius: const Radius.circular(8.0),
      lineHeight: 15,
      percent: percentValue,
      progressColor: Colors.grey,
      backgroundColor: Colors.black,
    );
  }
}

// class Nyoba extends StatelessWidget {
//   Nyoba({super.key,});
//   List<double> percentValue = [1,2,3];

//   @override
//   Widget build(BuildContext context) {
//     return const Row(
//       children: List.generate(3, (index) {
//         return RProgressBar(percentValue: percentValue);
//       },),
//     );
//   }
// }
