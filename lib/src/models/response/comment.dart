class CommentData {
  String? id;
  String? content;
  String? user;
  String? time;

  CommentData({
    this.id,
    this.user,
    this.content,
    this.time,
  });

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    user = json['user'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['user'] = user;
    data['time'] = time;
    return data;
  }
}
