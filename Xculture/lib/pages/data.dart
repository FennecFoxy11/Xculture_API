class Forum {
  final int id;
  final String title;
  final String subtitle;
  final String content;
  final String thumbnail;
  final String author;
  final bool incognito;
  final int viewed;
  final int favorited;
  final String date;
  final String updateDate;
  final List<Comment> comments;

  Forum({
    required this.id, 
    required this.title,
    required this.subtitle,
    required this.content,
    required this.thumbnail, 
    required this.author,
    required this.incognito,
    required this.viewed,
    required this.favorited,
    required this.date,
    required this.updateDate,
    required this.comments,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      content: json['content'],
      thumbnail: json['thumbnail'],
      author: json['author'],
      incognito: json['incognito'],
      viewed: json['viewed'],
      favorited: json['favorite_amount'],
      date: json['date'],
      updateDate: json['update_date'],
      comments: getCommentsFromJson(json['comments']),
    );
  }

  static List<Comment> getCommentsFromJson(comments) {
    List<Comment> list = [];
    if(comments != null) {
      comments.forEach( (obj) => list.add(Comment.fromJson(obj)));
    }
    return list;
  }
}

class Comment {
  final int id;
  final String content;
  final String author;
  final bool incognito;
  final int replied;
  final int favorited;
  final String date;
  final String updateDate;

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.incognito,
    required this.replied,
    required this.favorited,
    required this.date,
    required this.updateDate,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      content: json["body"],
      author: json["author"],
      incognito: json["incognito"],
      replied: json["reply_amount"],
      favorited: json["liked"],
      date: json["date"],
      updateDate: json["update_date"],
    );
  }
}