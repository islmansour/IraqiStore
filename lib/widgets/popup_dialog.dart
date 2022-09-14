import 'package:flutter/material.dart';

class ShowDiaglog extends StatelessWidget {
  final String? title;
  final String? content;
  Color titleColor = Colors.redAccent;
  final List<Widget> actions;

  ShowDiaglog({
    titleColor,
    this.title,
    this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        color: titleColor,
        child: Text(
          this.title!,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      actions: this.actions,
      contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      content: Container(
        height: 1,
        // decoration: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(width: 4.0, color: Colors.redAccent),
        //   ),
        //   //color: Colors.white,
        // ),
        // child: Text(
        //   this.content!,
        //   style: Theme.of(context).textTheme.bodyMedium,
        // ),
      ),
    );
  }
}
