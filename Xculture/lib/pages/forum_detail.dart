import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({Key? key}) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  Future<Forum>? fullDetail;
  
  @override
  Widget build(BuildContext context) {
    final forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;
    fullDetail = getFullDetail(forumDetail.id);
    setState(() {
      forumViewed(forumDetail.id);
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: FutureBuilder<Forum>(
            future: fullDetail,
            builder: (BuildContext context, AsyncSnapshot<Forum> snapshot) {
              if (snapshot.hasData) {
                DateTime dt = DateTime.parse(snapshot.data!.updateDate).toLocal();   // Type snapshot.data![index].updateDateChange is Sting => String to DateTime
                String formattedDate = DateFormat('dd/MM/yyyy – HH:mm a').format(dt);
                return Stack(

                  children: [
                    Positioned(
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 300,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!.thumbnail),
                            fit: BoxFit.cover
                          )
                        ),
                      )
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back))
                        ],
                      )
                    ),
                    Positioned(
                        top: 280,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 1200,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23)),
                              const SizedBox(height: 10),
                              Text(snapshot.data!.subtitle,
                                  style: const TextStyle(fontSize: 15)),
                              const SizedBox(height: 10),
                              const Text("Tags Area"),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(Icons.account_circle),
                                  SizedBox(width: 5),
                                  Text("Alex Wongwathana")
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(formattedDate),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 1.0,
                                width: 400,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 10),
                              const Text("Description",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Text(snapshot.data!.content),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  forumFavorited(snapshot.data!.id);
                                }, 
                                child: const Text("Favorite")
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  forumUnfavorited(snapshot.data!.id);
                                }, 
                                child: const Text("Unfavorite")
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'editForumPage', arguments: snapshot.data).then(refreshPage);
                                }, 
                                child: const Text("Edit forum")
                              ),
                              const SizedBox(height: 20),
                              const Text("Comments",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ))
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }
          )
        ),
      ),
    );
  }

  FutureOr refreshPage(forumID) {
    setState(() {
      fullDetail = getFullDetail(forumID);
    });
  }

  Future<Forum> getFullDetail(forumID) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/forums/$forumID'));

    if (response.statusCode == 200) {
      return Forum.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error");
    }
  }
  
  forumViewed(forumID) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/viewed'));
  
    if (response.statusCode == 200) {
    }
    else {
      throw Exception("Error");
    }
  }

  forumFavorited(forumID) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/favorite')
    );

    if (response.statusCode == 200) {

    }
    else {
      throw Exception("Error");
    }
  }

  forumUnfavorited(forumID) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/unfavorite')
    );

    if (response.statusCode == 200) {

    }
    else {
      throw Exception("Error");
    }
  }
}
