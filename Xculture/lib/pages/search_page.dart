import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/forum_new.dart';
import 'package:xculturetestapi/pages/forum_detail.dart';
import '../data.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

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
          title: const Center(
            child: Text(
              "Forum",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25),
            ),
          ),
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
        ));
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
              // DropdownButtonHideUnderline(
              //   child: Container(
              //     height: 30,
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     decoration: BoxDecoration(
              //       color: Colors.grey[300],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: DropdownButton(
              //       hint: const Text("Sort by..."),
              //       icon: const Icon(Icons.arrow_drop_down),
              //       items: sortList.map((value){
              //         return DropdownMenuItem(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              //       value: value,
              //       onChanged: (value) {
              //         setState(() {
              //           this.value = value as String?;
              //         });
              //       }
              //     ),
              //   ),
              // ),
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
                    return snapshot.data![index].title.toLowerCase().contains(searchString) ? InkWell(
                      child: 
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: 80,
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
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                                            Text(snapshot.data![index].subtitle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
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


}