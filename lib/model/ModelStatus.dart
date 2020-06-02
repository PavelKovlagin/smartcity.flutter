class ModelStatus{

  int _id;
  String _statusName;
  String _statusDescription;

  ModelStatus(int id, String statusName, String statusDescription) {
    _id = id;
    _statusName = statusName;
    _statusDescription = statusDescription;
  }

  factory ModelStatus.fromJson(Map<String, dynamic> json) {
    return ModelStatus(
      json["id"] as int,
      json["statusName"] as String,
      json["statusDescription"] as String
    );
  }

  int get id => _id;
  String get statusName => _statusName;
  String get statusDescription => _statusDescription;
}