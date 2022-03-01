import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../../arguments.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:xculturetestapi/navbar.dart';


class EditReplyPage extends StatefulWidget {
  const EditReplyPage({ Key? key }) : super(key: key);

  @override
  _EditReplyPageState createState() => _EditReplyPageState();
}

class _EditReplyPageState extends State<EditReplyPage> {
  final TextEditingController _content = TextEditingController();
  final TextEditingController _author = TextEditingController();
  bool? _incognito;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EditReplyArguments;
    _author.text = args.reply.author;
    _content.text = args.reply.content;
    (_incognito == null) ? _incognito = args.reply.incognito : _incognito ;


   return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Reply",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        )
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, args.forumID);
          return false;
        },
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  maxLines: 2,
                  controller: _content,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: "Content",
                    hintText: "Reply here",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter reply";
                    }
                    else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text("Incognito"),
                  subtitle: const Text("If incognito is on this post will hide author/owner username."),
                  value: _incognito!, 
                  onChanged: (value) {
                    setState(() {
                      _incognito = value;
                    });
                  }
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      updateReplyDetail(args.forumID, args.commentID, args.reply.id, _content.text, _incognito);
                      Fluttertoast.showToast(msg: "Your reply has been updated.");
                      Navigator.pop(context, args.forumID);
                    }
                  }, 
                  child: const Text('Edit Reply'),
                )
              ],
            ), 
          ),
        ),
      ),
      bottomNavigationBar: Navbar.navbar(context, 2),
    );
  }

  updateReplyDetail(forumID, commentID, replyID, content, incognito) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/comments/$commentID/replies/$replyID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'content': content,
        'incognito': incognito,
      }),
    );

    if (response.statusCode == 200) {

    }
    else {
      throw Exception(response.statusCode);
    }
  }
}

