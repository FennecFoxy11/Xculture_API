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
  final List<Tag> tags;

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
    required this.tags,
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
      tags: getTagsFromJson(json['tags']),
    );
  }

  static List<Comment> getCommentsFromJson(comments) {
    List<Comment> list = [];
    if(comments != null) {
      comments.forEach( (obj) => list.add(Comment.fromJson(obj)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;
  }

  static List<Tag> getTagsFromJson(tags) {
    List<Tag> list = [];
    if(tags != []) {
      tags.forEach( (obj) => list.add(Tag.fromForumJson(obj)));
      list.sort((a, b) => a.id.compareTo(b.id));
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
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.incognito,
    required this.replied,
    required this.favorited,
    required this.date,
    required this.updateDate,
    required this.replies,
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
      replies: getRepliesFromJson(json["replies"]),
    );
  }

  static List<Reply> getRepliesFromJson(replies) {
    List<Reply> list = [];
    if (replies != null) {
      replies.forEach( (obj) => list.add(Reply.fromJson(obj)));
      list.sort((a, b) => a.id.compareTo(b.id));
    }
    return list;

  }
}

class Reply {
  final int id;
  final String content;
  final String author;
  final bool incognito;
  final int favorited;
  final String date;
  final String updateDate;

  Reply({
    required this.id,
    required this.content,
    required this.author,
    required this.incognito,
    required this.favorited,
    required this.date,
    required this.updateDate,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json["id"],
      content: json["body"],
      author: json["author"],
      incognito: json["incognito"],
      favorited: json["liked_reply"],
      date: json["date"],
      updateDate: json["update_date"],
    );
  }
}

class Tag {
  final int id;
  final String name;
  final int usage;

  Tag({
    required this.id,
    required this.name,
    required this.usage,
  });

  factory Tag.fromForumJson(Map<String, dynamic> json) {
    return Tag(
      id: json["tag"]["id"],
      name: json["tag"]["name"],
      usage: json["tag"]["usage_amount"],
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["id"],
      name: json["name"],
      usage: json["usage_amount"],
    );
  }

  @override
  String toString() => name;

  @override
  operator ==(other) => other is Tag && other.id == id;

  @override
  int get hashCode => id.hashCode^name.hashCode;
}