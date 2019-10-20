class AppCategoryModel {
  String id;
  String title;
  String color;

  AppCategoryModel({this.id, this.title, this.color});

  factory AppCategoryModel.fromMap(Map<String, dynamic> json) => new AppCategoryModel(
      id: json["id"],
      title: json["title"],
      color: json["color"],
  );

  log() {
    print('id: $id');
    print('title: $title');
    print('color: $color');
  }
}
