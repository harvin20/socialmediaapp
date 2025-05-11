import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;

  const BioBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding inside
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        // color
        color: Theme.of(context).colorScheme.secondary,
      ), // BoxDecoration
      child: Text(
        text.isNotEmpty ? text : "Empty bio..",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ), // TextStyle
      ), // Text

    ); // Container
  }
}
 
