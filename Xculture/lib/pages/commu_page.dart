import 'package:flutter/material.dart';

class CommuPage extends StatefulWidget {
  const CommuPage({ Key? key }) : super(key: key);

  @override
  _CommuPageState createState() => _CommuPageState();
}

class _CommuPageState extends State<CommuPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("Community Page"),
      ),
    );
  }
}