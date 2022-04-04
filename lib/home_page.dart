// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_draggable_button/draggable_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(elevation: 0, title: Text(widget.title)),
        body: DraggableWidget(
          parent: ListView.builder(
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text('Item $index'),
              subtitle: Text('Subtitle $index'),
            ),
          ),
          child: ElevatedButton(child: const Text('Drag me'), onPressed: () {}),
        ),
      );
}
