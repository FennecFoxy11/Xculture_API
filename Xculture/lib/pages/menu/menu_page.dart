import 'package:flutter/material.dart';
import 'package:xculturetestapi/navbar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Menu",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        )
      ),
      body: Container(
        child: const Center(
          child: Text("Menu Page"),
        ),
      ),
      bottomNavigationBar: Navbar.navbar(context, 4),
    );
  }
}
