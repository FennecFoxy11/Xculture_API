import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:xculturetestapi/navbar.dart';

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
  bool? incognito;

  List<Tag> arr = [];
  Future<List<Tag>>? tags;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tags = getTags();
  }

  @override
  Widget build(BuildContext context) {
    final forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;

    if(incognito == null) {
      _title.text = forumDetail.title;
      _subtitle.text = forumDetail.subtitle;
      _thumbnail.text = forumDetail.thumbnail;
      _content.text = forumDetail.content;
      incognito = forumDetail.incognito;
      arr = forumDetail.tags;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Forum",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, forumDetail.id);
          return false;
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter forum's title";
                      }
                      else {
                        return null;
                      }
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter forum's subtitle";
                      }
                      else {
                        return null;
                      }
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter forum's thumbnail url";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<Tag>>(
                    future: tags,
                    builder: (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
                      if(snapshot.hasData) {
                        return Row(
                          children: [
                            const Text("Add Tags"),
                            const SizedBox(width: 20),
                            FindDropdown<Tag>(
                              items: snapshot.data,
                              onChanged: (item) {
                                setState(() {
                                  if(!arr.contains(item)){
                                    arr.add(item!);
                                  }
                                });
                              },
                              // ignore: deprecated_member_use
                              searchHint: "Search here",
                              backgroundColor: Colors.white,
                            ),
                          ],
                        );
                      }
                      else {
                        return const CircularProgressIndicator();
                      }
                    }
                  ),
                  const SizedBox(height: 20),
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: arr.map((e) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        label: Text(e.name),
                        deleteIcon: const Icon(Icons.clear),
                        onDeleted: () {
                          setState(() {
                            arr.remove(e);
                          });
                        },
                      ),
                    )).toList(),
                  ),
                ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter forum's content";
                      }
                      else {
                        return null;
                      }
                    },
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
                      if(_formKey.currentState!.validate()) {
                        updateForumDetail(forumDetail.id, _title.text, _subtitle.text, _thumbnail.text, _content.text, incognito!, arr);
                        Fluttertoast.showToast(msg: "Your post has been updated.");
                        Navigator.pop(context, forumDetail.id);
                      }
                    }, 
                    child: const Text("Edit Forum")
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          )
        )
      ),
      bottomNavigationBar: Navbar.navbar(context, 2),
    );
  }

  updateForumDetail(int forumID, String title, String subtitle, String thumbnailUrl, String content, bool incognito, List<Tag> tags) async {
    List<int> tagsID = [];
    for (var tag in tags) {
      tagsID.add(tag.id);
    }

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
        'tags': tagsID,
      }),
    );
    
    if (response.statusCode == 200) {

    }
    else {
      throw Exception("Error");
    }
  }

  Future<List<Tag>> getTags() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/tags'));
    final List<Tag> tagList = [];
    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => tagList.add(Tag.fromJson(obj)));
      return tagList;
    }
    else {
      throw Exception(response.statusCode);
    }

  }
}