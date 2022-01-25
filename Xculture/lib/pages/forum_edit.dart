import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';

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
  bool? incognito;

  @override
  Widget build(BuildContext context) {
    final forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;

    if(incognito == null) {
      _title.text = forumDetail.title;
      _subtitle.text = forumDetail.subtitle;
      _thumbnail.text = forumDetail.thumbnail;
      _content.text = forumDetail.content;
      _author.text = forumDetail.author;
      incognito = forumDetail.incognito;
    }

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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _subtitle,
                  decoration: const InputDecoration(
                    labelText: "Subtitle",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                /* Temporary Author field, will delete after user system has been implemented */
                const SizedBox(height: 20),
                TextFormField(
                  controller: _author,
                  decoration: const InputDecoration(
                    labelText: "Author",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _thumbnail,
                  decoration: const InputDecoration(
                    labelText: "Upload Forum Thumbnail",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    /* const */ Text("Add Tags"),
                    /* const */ SizedBox(width: 20),
                    /*
                    FindDropdown(
                      items: tags,
                      onChanged: (item) {
                        setState(() {
                          if(!arr.contains(item)){
                            arr.add(item.toString());
                            print(arr);
                          }
                        });
                      },
                      // ignore: deprecated_member_use
                      searchHint: "Search Here",
                      backgroundColor: Colors.white,
                    ),
                    */
                  ],
                ),
                const SizedBox(height: 20),
                /*
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: arr.map((e) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(e),
                      deleteIcon: const Icon(Icons.clear),
                      onDeleted: () {
                        setState(() {
                          arr.remove(e);
                        });
                      },
                    ),
                  )).toList(),
                ),
                */
                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: _content,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Content Here",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text("Incognito"),
                  activeColor: Theme.of(context).primaryColor,
                  subtitle: const Text("If incognito is on this post will hide author/owner username."),
                  value: incognito!, 
                  onChanged: (selected){
                    setState(() {
                      incognito = !incognito!;
                    });
                  }
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350, 50),
                  ),
                  onPressed: (){
                    // Fluttertoast.showToast(msg: "Your post have been created.");
                    updateForumDetail(forumDetail.id, _title.text, _subtitle.text, _thumbnail.text, _content.text, _author.text, incognito!);
                    Navigator.pop(context, forumDetail.id);
                  }, 
                  child: const Text("Edit Forum")
                ),
                const SizedBox(height: 50),
              ],
            ),
          )
        )
      )
    );
  }

  updateForumDetail(int forumID, String title, String subtitle, String thumbnailUrl, String content, String author, bool incognito) async {
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
      }),
    );
    
    if (response.statusCode == 200) {

    }
    else {
      throw Exception("Error");
    }
  }
}