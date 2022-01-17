import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/pages/data.dart';

class EditForumPage extends StatefulWidget {
  const EditForumPage({ Key? key }) : super(key: key);

  @override
  _EditForumPageState createState() => _EditForumPageState();
}

class _EditForumPageState extends State<EditForumPage>{
  final TextEditingController _title = TextEditingController();
  final TextEditingController _subtitle = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;
    _title.text = forumDetail.title;
    _subtitle.text = forumDetail.subtitle;
    _thumbnail.text = forumDetail.thumbnail;
    _content.text = forumDetail.content;

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
            decoration: const InputDecoration(),
          ),
          TextField(
            controller: _subtitle,
            decoration: const InputDecoration(),
          ),
          TextField(
            controller: _thumbnail,
            decoration: const InputDecoration(),
          ),
          TextField(
            controller: _content,
            decoration: const InputDecoration(),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                updateForumDetail(forumDetail.id, _title.text, _subtitle.text, _thumbnail.text, _content.text, 
                forumDetail.incognito, forumDetail.viewed, forumDetail.favorited, forumDetail.date);
              });
              Navigator.pop(context, forumDetail.id);
            }, 
            child: const Text('Post Forum'),
          )
        ],
      ),
    );
  }

  updateForumDetail(int forumID, String title, String subtitle, String thumbnailUrl, String content, bool incognito, int viewed, int favorited, String date) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'subtitle': subtitle,
        'thumbnail': thumbnailUrl,
        'content': content,
        'incognito': incognito,
        'viewed': viewed,
        'favorited': favorited,
        'date': date,
      }),
    );
    
    if (response.statusCode == 200) {

    }
    else {
      throw Exception("Error");
    }
  }
}