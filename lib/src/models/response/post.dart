class PostData {
  String? id;
  String? image;
  String? body;
  String? time;
  String? user;

  PostData({
    this.id,
    this.image,
    this.body,
    this.time,
    this.user,
  });

  PostData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    body = json['body'];
    time = json['time'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['body'] = body;
    data['time'] = time;
    data['user'] = user;
    return data;
  }
}
