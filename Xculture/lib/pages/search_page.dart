import 'dart:async';
import '../data.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/pages/forum/forum_new.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';
import 'package:xculturetestapi/navbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  Future<List<Forum>>? _futureForum;
  String? value;
  List sortList = [
    "Newest",
    "Oldest",
    "Most Viewed",
    "Most Favorited"
  ];

  String searchString = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureForum = getForums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        )
      ),
      body: showAllForum(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewForumPage(),
            )
          );
        },
        child: const Icon(Icons.post_add)
      ),
      bottomNavigationBar: Navbar.navbar(context, 1),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      _futureForum = getForums();
    });
  }

  Widget showAllForum() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                      setState((){
                        searchString = value; 
                      });
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Here...",
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<List<Forum>>(
            builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var dt = DateTime.parse(snapshot.data![index].updateDate).toLocal();
                    String formattedDate = DateFormat('dd/MM/yyyy – HH:mm a').format(dt);
                    var contained = isContain(snapshot.data![index], searchString);
                    return contained ? InkWell(
                      child: 
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                                      ),
                                    ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data![index].title,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                                            Text(snapshot.data![index].subtitle,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.start,
                                              children: snapshot.data![index].tags.map((tag) => Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Chip(
                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Chip size -4 -> 4
                                                  label: Text(tag.name),
                                                ),
                                              )).toList(),
                                            ),
                                          ],
                                        )
                                      ),
                                      const SizedBox(height: 5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(snapshot.data![index].author,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              //color: Colors.black,
                                            ),
                                          ),
                                          Text(formattedDate,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              //color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForumDetailPage(),
                              settings: RouteSettings(
                                arguments: snapshot.data![index],
                              ),
                            )
                          );
                        },
                    ) : Container();
                  },
                );
              }
              else {
                return const CircularProgressIndicator();
              }
            }, future: _futureForum
          ),
        )      
      ],
    );
  }

  Future<List<Forum>> getForums() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/forums'));
    final List<Forum> forumList = [];

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => forumList.add(Forum.fromJson(obj)));
      return forumList;
    } 
    else {
      throw Exception('Failed to get forums.');
    }

  } 

  bool isContain(Forum data, String search) {
    var isContain = false;

    if (data.title.toLowerCase().contains(search)) {
      isContain = true;
    }
    else if (data.tags.isNotEmpty) {
      for (var tag in data.tags) {
        if(tag.name.toLowerCase().contains(search)) {
          isContain = true;
        }
      }
    }

    return isContain;
  }
}
