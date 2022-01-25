import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/Navbar.dart';
import 'package:xculturetestapi/pages/forum_home.dart';
// import 'package:xculturetestapi/pages/comment_edit.dart';
// import 'package:xculturetestapi/pages/forum_all.dart';
// import 'package:xculturetestapi/pages/forum_edit.dart';
// import 'package:xculturetestapi/pages/forum_detail.dart';
// import 'package:xculturetestapi/pages/forum_new.dart';
// import 'package:xculturetestapi/pages/reply_edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: "Poppins",
      ),
      
      initialRoute: 'navbar', // Set first page
      routes: {
        'navbar': (context) => const NavBar(),
        'homePage': (context) => const ForumPage(),
        // 'forumAllPage': (context) => const ForumAllPage(),
        // 'forumDetailPage': (context) => const ForumDetailPage(),
        // 'newForumPage': (context) => const NewForumPage(),
        // 'editForumPage': (context) => const EditForumPage(), 
        // 'editCommentPage': (context) => const EditCommentPage(),
        // 'editReplyPage': (context) => const EditReplyPage(), // Change page by using only page's name
      },
    );
  }
}









