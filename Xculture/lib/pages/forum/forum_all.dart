import '../../data.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/NavBar.dart';
import 'package:xculturetestapi/pages/forum/forum_new.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';



class ForumAllPage extends StatefulWidget {
  const ForumAllPage({Key? key}) : super(key: key);

  @override
  _ForumAllPageState createState() => _ForumAllPageState();
}

class _ForumAllPageState extends State<ForumAllPage> {

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
  Widget build(BuildContext context) {
    final forumList =
        ModalRoute.of(context)!.settings.arguments as Future<List<Forum>>;

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
        body: showAllForum(forumList),
        // bottomNavigationBar: BottomNavigationBar(const NavBar()),
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
    );
  }

  Widget showAllForum(Future<List<Forum>> dataList) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Text("Trending Forum", style: TextStyle(fontSize: 20)),
        ),
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
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    hint: const Text("Sort by..."),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: sortList.map((value){
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value as String?;
                      });
                    }
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
                    return snapshot.data![index].title.toLowerCase().contains(searchString) ? InkWell(
                      // padding: const EdgeInsets.all(20.0),
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
                                      // Tags
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      //   child: Wrap(
                                      //     crossAxisAlignment: WrapCrossAlignment.start,
                                      //     children: snapshot.data![index].tags.map((tag) => Padding(
                                      //       padding: const EdgeInsets.only(right: 10),
                                      //       child: Chip(
                                      //         label: Text(tag.name),
                                      //       ),
                                      //     )).toList(),
                                      //   ),
                                      // ),
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
            }, future: dataList
          ),
        )      
      ],
    );
  }
}
