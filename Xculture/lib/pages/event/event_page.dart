import 'package:flutter/material.dart';
import 'package:xculturetestapi/navbar.dart';

class EventPage extends StatefulWidget {
  const EventPage({ Key? key }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Event",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        )
      ),
      body: Container(
        child: const Center(
          child: Text("Event Page"),
        ),
      ),
      bottomNavigationBar: Navbar.navbar(context, 0),
    );
  }
}