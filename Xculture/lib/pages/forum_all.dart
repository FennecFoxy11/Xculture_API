import 'package:flutter/material.dart';
import 'data.dart';

class ForumAllPage extends StatefulWidget {
  const ForumAllPage({Key? key}) : super(key: key);

  @override
  _ForumAllPageState createState() => _ForumAllPageState();
}

class _ForumAllPageState extends State<ForumAllPage> {
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "newForumPage");
          },
          child: const Icon(Icons.near_me),
        ));
  }

  Widget showAllForum(Future<List<Forum>> dataList) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10.0),
          child: const Text("Forum", style: TextStyle(fontSize: 25),)
        ),
        Expanded(
          child: FutureBuilder<List<Forum>>(
            builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].subtitle),
                      onTap: () {
                        Navigator.pushNamed(context, "forumDetailPage", arguments: snapshot.data![index]);
                      },
                    );
                  },
                );
              }
              else {
                return const CircularProgressIndicator();
              }
            },
            future: dataList,
          )
        )
      ],
    );
  }
}
