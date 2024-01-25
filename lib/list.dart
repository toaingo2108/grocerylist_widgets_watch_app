import 'package:flutter/material.dart';

class ListWidget extends StatefulWidget {
  final int count;
  const ListWidget({super.key, required this.count});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${widget.count}"),
    );
  }
}
