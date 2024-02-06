class FavouriteData {
  bool? male;
  bool? female;

  FavouriteData({
    this.male,
    this.female,
  });

  FavouriteData.fromJson(Map<String, dynamic> json) {
    male = json['male'];
    female = json['female'];
  }

  Map<String, dynamic> toMaleJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['male'] = male;
    return data;
  }

  Map<String, dynamic> toFemaleJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['female'] = female;
    return data;
  }
}
