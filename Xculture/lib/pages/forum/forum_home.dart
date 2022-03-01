import 'dart:async';
import 'dart:convert';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/pages/forum/forum_new.dart';
import 'package:xculturetestapi/pages/forum/forum_all.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';



class ForumPage extends StatefulWidget {
  const ForumPage({ Key? key }) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<Forum>>? _futureForum;

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
          "Forum",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        )
      ),
      body: showTopFiveForum(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewForumPage(),
            )
          ).then(refreshPage);
        },
        child: const Icon(Icons.post_add)
      ),
      bottomNavigationBar: Navbar.navbar(context, 2),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      _futureForum = getForums();
    });
  }

  Widget showTopFiveForum() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Trending Forum",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                  // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForumAllPage(),
                      settings: RouteSettings(
                        arguments: _futureForum,
                      ),
                    )
                  ).then(refreshPage);
                }, 
                child: const Text("see all")),
              ],
            ),
          ),
          Container(
            height: 250,
            width: double.maxFinite,
            child: FutureBuilder<List<Forum>>(
              builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
                if (snapshot.hasData) {
                  snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
                  return ListView.builder(
                    itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightBlue[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 5.0,
                                offset: const Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 120,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data![index].title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(snapshot.data![index].subtitle,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: snapshot.data![index].tags.take(2).map((tag) => Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Chip(
                                          label: Text(tag.name),
                                        ),
                                      )).toList(),
                                    ),
                                  ],
                                ),
                              )
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
                          ).then(refreshPage);
                        },
                      );
                    }
                  );
                }
                else {
                  return const CircularProgressIndicator();
                }
              },
              future: _futureForum,
            )
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Newest Forum",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                  /*
                  // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForumAllPage(),
                      settings: RouteSettings(
                        arguments: _futureForum,
                      ),
                    )
                  ).then(refreshPage);
                  */
                }, 
                child: const Text("see all")),
              ],
            ),
          ),
          /*
          Container(
            height: 250,
            width: double.maxFinite,
            child: FutureBuilder<List<Forum>>(
              builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
                if (snapshot.hasData) {
                  snapshot.data!.sort((b, a) => a.updateDate.compareTo(b.updateDate));
                  return ListView.builder(
                    itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightBlue[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 5.0,
                                offset: const Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 120,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data![index].title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(snapshot.data![index].subtitle,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: snapshot.data![index].tags.take(2).map((tag) => Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Chip(
                                          label: Text(tag.name),
                                        ),
                                      )).toList(),
                                    ),
                                  ],
                                ),
                              )
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
                          ).then(refreshPage);
                        },
                      );
                    }
                  );
                }
                else {
                  return const CircularProgressIndicator();
                }
              },
              future: _futureForum,
            )
          ),
          */
        ],
      ),
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

}