import 'package:apnea_aware/app/constants/constants.dart';
import 'package:flutter/material.dart';

class ReadingCard extends StatelessWidget {
  final String text;
  final double? value;

  const ReadingCard({
    Key? key,
    required this.text,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: scaffoldColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  textAlign: TextAlign.center,
                  style: appText(
                    color: heartColor,
                    weight: FontWeight.w700,
                  ).copyWith(fontSize: 25)),
              const Divider(
                thickness: 5,
              ),
              Text(
                value.toString(),
                style: appText(color: Colors.white, weight: FontWeight.w700)
                    .copyWith(
                  fontSize: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
