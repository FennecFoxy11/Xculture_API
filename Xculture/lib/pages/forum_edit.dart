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
  final TextEditingController _author = TextEditingController();
  bool? _incognito;

  @override
  Widget build(BuildContext context) {
    final forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;
    _title.text = forumDetail.title;
    _subtitle.text = forumDetail.subtitle;
    _thumbnail.text = forumDetail.thumbnail;
    _content.text = forumDetail.content;
    _author.text = forumDetail.author;
    (_incognito == null) ? _incognito = forumDetail.incognito : _incognito ;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Edit Forum",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, forumDetail.id);
          return false;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _title,
            ),
            TextField(
              controller: _subtitle,
            ),
            TextField(
              controller: _author,
            ),
            TextField(
              controller: _thumbnail,
            ),
            TextField(
              controller: _content,
            ),
            Switch(
              value: _incognito!, 
              onChanged: (value) {
                setState(() {
                  _incognito = value;
                });
              }
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  updateForumDetail(forumDetail.id, _title.text, _subtitle.text, _thumbnail.text, _content.text, 
                  _author.text, _incognito!, forumDetail.viewed, forumDetail.favorited, forumDetail.date);
                });
                Navigator.pop(context, forumDetail.id);
              }, 
              child: const Text('Edit Forum'),
            )
          ],
        ),
      )
    );
  }

  updateForumDetail(int forumID, String title, String subtitle, String thumbnailUrl, String content, String author, bool incognito, int viewed, int favorited, String date) async {
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
        'author': author,
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