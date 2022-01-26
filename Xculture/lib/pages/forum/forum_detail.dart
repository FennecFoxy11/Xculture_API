import 'dart:async';
import 'package:xculturetestapi/data.dart';
import 'dart:convert';
import 'package:xculturetestapi/arguments.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/pages/forum/forum_edit.dart';
import 'package:xculturetestapi/pages/reply/reply_edit.dart';
import 'package:xculturetestapi/pages/comments/comment_edit.dart';
import 'package:xculturetestapi/navbar.dart';



class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({ Key? key }) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  Future<Forum>? fullDetail;

  final TextEditingController _contentComment = TextEditingController();
  final List<TextEditingController> _contentReplies = [];
  final List<bool> incognitoReplies = [];
  final List<bool> _favComments = [];
  final List<bool> _isReply = [];
  final List<bool> _isShowReply = [];
  final List<List<bool>> _favRepliesTotal = [];
  bool incognitoComment = false;
  bool incognitoReply = false;
  bool favourite = false;
  bool _favComment = false;
  bool _favReply = false;
  bool isReply = false;
  bool isShowReply = false;
  bool isFirstVisited = true;

  @override
  Widget build(BuildContext context) {
    final forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;
    fullDetail = getFullDetail(forumDetail.id);

    if(isFirstVisited) {
      setState(() {
        forumViewed(forumDetail.id);
        isFirstVisited = !isFirstVisited;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: FutureBuilder<Forum>(
            future: fullDetail,
            builder: (BuildContext context, AsyncSnapshot<Forum> snapshot) {
              if (snapshot.hasData) {
                var viewed = snapshot.data!.viewed.toString();
                var favorited = snapshot.data!.favorited.toString();
                var dt = DateTime.parse(snapshot.data!.updateDate).toLocal();
                String dateforum = DateFormat.yMMMMd('en_US').format(dt);
                for (var comment in snapshot.data!.comments) {
                  final TextEditingController _contentReply = TextEditingController();
                  List<bool> _favRepliesPerComment = [];
                  var index = snapshot.data!.comments.indexOf(comment);

                  _contentReplies.add(_contentReply);
                  incognitoReplies.add(incognitoReply);
                  _favComments.add(_favComment);
                  _isReply.add(isReply);
                  _isShowReply.add(isShowReply);
                  if(_favRepliesTotal.length < snapshot.data!.comments.length){
                      _favRepliesTotal.add(_favRepliesPerComment);
                    }
                  

                  for(var reply in comment.replies) {
                    if(_favRepliesTotal[index].length < comment.replies.length){
                      _favRepliesTotal[index].add(_favReply);
                    }
                  }
                }

                return Stack(
                    children: [
                      Container(
                        height: 10000, //set height by manual
                      ),
                      // Thumbnail Image
                      Positioned(
                        right: 0,
                        left: 0,
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data!.thumbnail),
                              fit: BoxFit.cover, 
                            )
                          ),
                        )
                      ),
                      // Iconbutton back
                      Positioned(
                        top: 40,
                        left: 20,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),   
                      ),
                      // Iconbutton menu
                      Positioned(
                        top: 40,
                        right: 20,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.edit),
                            // icon: const Icon(Icons.more_vert),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditForumPage(),
                                  settings: RouteSettings(
                                    arguments: snapshot.data,
                                  ),
                                )
                              ).then(refreshPage);
                            },
                          ),
                        ),
                      ),
                      // Details/Contents
                      Positioned(
                        top: 280,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title with favorite button
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Table(
                                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                                  columnWidths: const {1: FractionColumnWidth(.1)},
                                  children: [
                                    TableRow(
                                      children: [
                                        Text(snapshot.data!.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.red)
                                        ),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          icon: favourite == false ? const Icon(Icons.favorite_border) : const Icon(Icons.favorite),
                                          color: Colors.red,
                                          iconSize: 30,
                                          onPressed: () {
                                            setState(() { 
                                              if (favourite == false ) {
                                                favourite = true;
                                                forumFavorited(snapshot.data!.id);
                                                Fluttertoast.showToast(msg: "Favorite Changes.");
                                              } else {
                                                favourite = false;
                                                Fluttertoast.showToast(msg: "Favorite Changes.");
                                                forumUnfavorited(snapshot.data!.id);
                                              }                            
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Subtitle
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.subtitle,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),

                              // Tags
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: snapshot.data!.tags.map((tag) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Chip(
                                      label: Text(tag.name),
                                    ),
                                  )).toList(),
                                ),
                              ),
                              // Author
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.account_circle),
                                    const SizedBox(width: 5),
                                    (snapshot.data!.incognito == false) ? Text(snapshot.data!.author) : const Text("Author")
                                  ],
                                ),
                              ),
                              // Date and Like/Favorite count
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Text(dateforum),
                                    const Spacer(),
                                    Row(
                                      children: [
                                          const Icon(Icons.visibility_sharp),
                                          const SizedBox(width: 5),
                                          Text(viewed),                    //total viewed
                                          const SizedBox(width: 5),
                                          const Icon(Icons.favorite),
                                          const SizedBox(width: 5),
                                          Text(favorited),                 //total favourite
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Division line
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Container(
                                    height: 1.0,
                                    width: 400,
                                    color: Colors.grey,
                                ),
                              ),
                              // Desc Header
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Description",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Desc Content
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.content),
                              ),
                              // Comment Header
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Comments",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Comment Box
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage("assets/images/yukinon.jpeg"),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: TextFormField(
                                            minLines: 1,
                                            maxLines: 3,
                                            controller: _contentComment,
                                            keyboardType: TextInputType.multiline,
                                            decoration: const InputDecoration(
                                              hintText: "Type your comment...",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              isDense: true, // important line
                                              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 15), // adjust form size
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Incognito : "),
                                        Switch(
                                          value: incognitoComment, 
                                          onChanged: (value) {
                                            setState(() {
                                              incognitoComment = value;
                                            });
                                          }
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              sendCommentDetail(snapshot.data!.id, _contentComment.text, incognitoComment);
                                              refreshPage(snapshot.data!.id);
                                            });
                                          }, 
                                          child: const SizedBox(
                                            width: 100,
                                            height: 30,
                                            child: Center(
                                              child: Text("Comment"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Commented List
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: ListView.builder(
                                  itemCount: snapshot.data!.comments.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    var favComments = snapshot.data!.comments[index].favorited.toString();
                                    var replied = snapshot.data!.comments[index].replied.toString();
                                    var dt = DateTime.parse(snapshot.data!.comments[index].updateDate).toLocal();
                                    var datecomment = DateFormat('HH:mm a').format(dt);
                                    
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                ListTile(
                                                  leading: const CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: AssetImage("assets/images/yukinon.jpeg"),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      Expanded(
                                                        // Condition of incognito
                                                        child: (snapshot.data!.comments[index].incognito == false) ? 
                                                        Text(snapshot.data!.author, 
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1
                                                        ) : const Text("Author",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                        ),
                                                      ),
                                                      // Date time
                                                      Text(datecomment, style: const TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                  subtitle: Text(snapshot.data!.comments[index].content),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextButton(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          padding: const EdgeInsets.only(left: 10),
                                                          child: Text(replied + " Replies"),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _isShowReply[index] = !_isShowReply[index];
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    IconButton(
                                                      visualDensity: VisualDensity.compact,
                                                      icon: _favComments[index] == false ? const Icon(Icons.thumb_up_alt_outlined) : const Icon(Icons.thumb_up),
                                                      color: Colors.red,
                                                      iconSize: 20,
                                                      onPressed: () {
                                                        setState(() { 
                                                          if (_favComments[index] == false ) {
                                                            _favComments[index] = true;
                                                            commentFavorited(snapshot.data!.id, snapshot.data!.comments[index].id);
                                                            Fluttertoast.showToast(msg: "Favorite Comment.");
                                                          } else {
                                                            _favComments[index] = false;
                                                            Fluttertoast.showToast(msg: "Unfavorite Comment.");
                                                            commentUnfavorited(snapshot.data!.id, snapshot.data!.comments[index].id);
                                                          }                            
                                                        });
                                                      },
                                                    ),
                                                    Text(favComments, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                    
                                                    TextButton(
                                                      child: Row(
                                                        children: const [
                                                          Icon(Icons.reply, size: 20),
                                                          SizedBox(width: 5),
                                                          Text('Reply'),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isReply[index] = !_isReply[index];
                                                        });
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Row(
                                                        children: const [
                                                          Icon(Icons.edit, size: 20),
                                                          SizedBox(width: 5),
                                                          Text('Edit'),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => const EditCommentPage(),
                                                              settings: RouteSettings(
                                                                arguments: EditCommentArguments(
                                                                  forumID: snapshot.data!.id, 
                                                                  comment: snapshot.data!.comments[index]
                                                                ),
                                                              )
                                                            )
                                                          ).then(refreshPage);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Reply TextField
                                          Visibility(
                                            visible: _isReply[index],
                                            child: Column(
                                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              children: [
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: AssetImage("assets/images/tomoe.jpg"),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 2,
                                                        controller: _contentReplies[index],
                                                        keyboardType: TextInputType.multiline,
                                                        decoration: const InputDecoration(
                                                          hintText: "Type your reply...",
                                                          border: InputBorder.none,
                                                          isDense: true, // important line
                                                          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 15), // adjust form size
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Incognito : "),
                                                    Switch(
                                                      value: incognitoReplies[index], 
                                                      onChanged: (value) {
                                                        setState(() {
                                                          incognitoReplies[index] = value;
                                                        });
                                                      }
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          sendReplyDetail(snapshot.data!.id, snapshot.data!.comments[index].id, _contentReplies[index].text, incognitoReplies[index]);
                                                          refreshPage(snapshot.data!.id);
                                                        });
                                                      }, 
                                                      icon: const Icon(Icons.reply),
                                                      iconSize: 25,
                                                    ),
                                                  ],
                                                ),
                                              ]
                                            ),
                                          ),
                                          // Reply List
                                          Visibility(
                                            visible: _isShowReply[index],
                                            child: ListView.builder(
                                              itemCount: snapshot.data!.comments[index].replies.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index2) {
                                                var favReply = snapshot.data!.comments[index].replies[index2].favorited.toString();
                                                var dt = DateTime.parse(snapshot.data!.comments[index].replies[index2].updateDate).toLocal();
                                                String datereplies = DateFormat('HH:mm a').format(dt);
                                                return Container(
                                                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 10), // adjust box size
                                                  child: Card(
                                                    color: Colors.grey[300],
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(height: 10),
                                                        ListTile(
                                                          leading: const CircleAvatar(
                                                            radius: 20,
                                                            backgroundImage: AssetImage("assets/images/Rengoku.jpg"),
                                                          ),
                                                          title: Row(
                                                            children: [
                                                              Expanded(   
                                                                child: (snapshot.data!.comments[index].replies[index2].incognito == false) ? 
                                                                  Text(snapshot.data!.comments[index].replies[index2].author, 
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1,
                                                                  ) : const Text("Author",
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1,
                                                                  ),
                                                              ),
                                                              Text(datereplies, style: const TextStyle(fontSize: 12)),
                                                            ],
                                                          ),
                                                          subtitle: Text(snapshot.data!.comments[index].replies[index2].content),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            IconButton(
                                                              visualDensity: VisualDensity.compact,
                                                              icon: _favRepliesTotal[index][index2] == false ? const Icon(Icons.thumb_up_alt_outlined) : const Icon(Icons.thumb_up),
                                                              color: Colors.red,
                                                              iconSize: 20,
                                                              onPressed: () {
                                                                setState(() { 
                                                                  if (_favRepliesTotal[index][index2] == false ) {
                                                                    _favRepliesTotal[index][index2] = true;
                                                                    replyFavorited(snapshot.data!.id, snapshot.data!.comments[index].id, snapshot.data!.comments[index].replies[index2].id);
                                                                    Fluttertoast.showToast(msg: "Favorite Reply.");
                                                                  } else {
                                                                    _favRepliesTotal[index][index2] = false;
                                                                    Fluttertoast.showToast(msg: "Unfavorite Reply.");
                                                                    replyUnfavorited(snapshot.data!.id, snapshot.data!.comments[index].id, snapshot.data!.comments[index].replies[index2].id);
                                                                  }                            
                                                                });
                                                              },
                                                            ),
                                                            Text(favReply, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                            TextButton(
                                                              child: Row(
                                                                children: const [
                                                                  Icon(Icons.edit, size: 20),
                                                                  SizedBox(width: 5),
                                                                  Text('Edit'),
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => const EditReplyPage(),
                                                                      settings: RouteSettings(
                                                                        arguments: EditReplyArguments(
                                                                          forumID: snapshot.data!.id, 
                                                                          commentID: snapshot.data!.comments[index].id,
                                                                          reply: snapshot.data!.comments[index].replies[index2]
                                                                        ),
                                                                      )
                                                                    )
                                                                  ).then(refreshPage);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                ),
                              ),
                              /*
                              // You may also like header
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("You may also like",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                              ),
                              // You may also like content
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    itemCount: 5, // number of item to display
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
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
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20),
                                                    topRight: Radius.circular(20),
                                                  ),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage("assets/images/tomoe.jpg") // Forum Image
                                                  ),
                                                ),
                                              )
                                            ),
                                            Positioned(
                                              top: 140,
                                              left: 20,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    "Jaikere",
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Forum Title
                                                  ),
                                                  Text(
                                                    "Jaikere",
                                                    style: TextStyle(fontSize: 15), // Forum Subtitle
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  ),
                                ),
                              ),
                              */
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
              } else {
                  return const CircularProgressIndicator();
              }
            }
          ),
        ),
      ),
      bottomNavigationBar: Navbar.navbar(context, 2),
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

  sendCommentDetail(forumID, content, incognito) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'content': content,
        'incognito': incognito,
      }),
    );

    if (response.statusCode == 201) {

    }
    else {
      throw Exception(response.statusCode);
    }
  }

  commentFavorited(forumID, commentID) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/comments/$commentID/favorite')
    );

    if (response.statusCode == 200) {

    }
    else {
      throw Exception(response.statusCode);
    }
  }

  commentUnfavorited(forumID, commentID) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/comments/$commentID/unfavorite')
    );

    if (response.statusCode == 200) {

    }
    else {
      throw Exception(response.statusCode);
    }
  }

  sendReplyDetail(forumID, commentID, content, incognito) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/comments/$commentID/replies'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'content': content,
        'incognito': incognito,
      }),
    );

    if (response.statusCode == 201) {

    }
    else {
      throw Exception(response.statusCode);
    }
  }

  replyFavorited(forumID, commentID, replyID) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/comments/$commentID/replies/$replyID/favorite')
    );

    if (response.statusCode == 200) {

    }
    else {
      throw Exception(response.statusCode);
    }
  }

  replyUnfavorited(forumID, commentID, replyID) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID/comments/$commentID/replies/$replyID/unfavorite')
    );

    if (response.statusCode == 200) {

    }
    else {
      throw Exception(response.statusCode);
    }
  }


}