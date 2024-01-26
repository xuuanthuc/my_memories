class PostData {
  int? id;
  String? image;
  String? body;
  String? time;

  PostData({
    this.id,
    this.image,
    this.body,
    this.time
  });

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['title'];
    body = json['body'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = image;
    data['body'] = body;
    data['time'] = time;
    return data;
  }
}
