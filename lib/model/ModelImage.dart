class ModelImage {
 
  int _image_id;
  String _image_name; 
  int _user_id;
  int _user_levelRights;

  ModelImage(
        int image_id, 
        String image_name, 
        int user_id, 
        int user_levelRights) {
    this._image_id = image_id;
    this._image_name = image_name;
    this._user_id = user_id;
    this._user_levelRights = user_levelRights;
  }

  factory ModelImage.fromJson(Map<String, dynamic> json){
    return ModelImage(
      json["image_id"],
      json["image_name"],
      json["user_id"],
      json["user_levelRights"]
    ); 
  }  

  int get image_id => _image_id;
  String get image_name => _image_name;
  int get user_id => _user_id;
  int get user_levelRights => _user_levelRights;

  set image_id(int value) {
    _image_id = value;
  }
  
  set image_name(String value) {
    _image_name = value;
  }

  set user_id(int value) {
    _user_id = value;
  }

  set user_levelRights(int value) {
    _user_levelRights = value;
  }

}