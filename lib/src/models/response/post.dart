class PostData {
  String? id;
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
    image = json['image'];
    body = json['body'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['body'] = body;
    data['time'] = time;
    return data;
  }
}
