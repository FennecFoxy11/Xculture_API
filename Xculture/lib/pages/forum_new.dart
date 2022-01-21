import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewForumPage extends StatefulWidget {
  const NewForumPage({ Key? key }) : super(key: key);

  @override
  _NewForumPageState createState() => _NewForumPageState();
}

class _NewForumPageState extends State<NewForumPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _subtitle = TextEditingController();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _content = TextEditingController();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Post Forum",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: _subtitle,
            decoration: const InputDecoration(hintText: "Subtitle"),
          ),
          TextField(
            controller: _author,
            decoration: const InputDecoration(hintText: "Author"),
          ),
          TextField(
            controller: _thumbnail,
            decoration: const InputDecoration(hintText: "Thumbnail url"),
          ),
          TextField(
            controller: _content,
            decoration: const InputDecoration(hintText: "Content"),
          ),
          Switch(
            value: isSwitched, 
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            }
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                sendForumDetail(_title.text, _subtitle.text, _author.text, _thumbnail.text, _content.text, isSwitched);
              });
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            }, 
            child: const Text('Post Forum'),
          )
        ],
      ),
    );
  }

  sendForumDetail(String title, String subtitle, String author, String thumbnailUrl, String content, bool isSwitched) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/forums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'subtitle': subtitle,
        'author': author,
        'thumbnail': thumbnailUrl,
        'content': content,
        'incognito': isSwitched,
      }),
    );

    if (response.statusCode == 201) {

    }
    else {
      throw Exception("Failed to post the forum");
    }
  }
}