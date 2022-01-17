import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'data.dart';
import 'package:intl/intl.dart';

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
        title: const Center(
          child: Text(
            "Forum",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
      ),
      body: showTopFiveForum(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "newForumPage").then(refreshPage);
        },
        child: const Icon(Icons.near_me),
      )
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
                TextButton(onPressed: () {
                  Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
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
                  return ListView.builder(
                    itemCount: (snapshot.data!.length <= 6) ? snapshot.data?.length : 6,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime dt = DateTime.parse(snapshot.data![index].updateDate).toLocal();   // Type snapshot.data![index].updateDateChange is Sting => String to DateTime
                      String formattedDate = DateFormat('yyyy/MM/dd – HH:mm a').format(dt);       // Format Datetime
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
                              Positioned(
                                top: 0,
                                child: Container(
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
                                )
                              ),
                              Positioned(
                                top: 140,
                                left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Forum Title
                                    ),
                                    Text(
                                      snapshot.data![index].subtitle,
                                      style: const TextStyle(fontSize: 15), // Forum Subtitle
                                    ), 
                                    Text( 
                                      formattedDate,
                                      style: const TextStyle(fontSize: 15), // Forum Date
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, 'forumDetailPage', arguments: snapshot.data![index]);
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