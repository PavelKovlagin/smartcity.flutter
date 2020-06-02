class ModelCategory{

  int _id;
  String _categoryName;
  String _categoryDescription;

  ModelCategory(int id, String categoryName, String categoryDescription) {
    _id = id;
    _categoryName = categoryName;
    _categoryDescription = categoryDescription;
  }

  factory ModelCategory.fromJson(Map<String, dynamic> json) {
    return ModelCategory(
      json["id"] as int,
      json["categoryName"] as String,
      json["categoryDescription"] as String
    );
  }

  int get id => _id;
  String get categoryName => _categoryName;
  String get categoryDescription => _categoryDescription;
}