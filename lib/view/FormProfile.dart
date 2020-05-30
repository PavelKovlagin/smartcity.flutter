import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelUser.dart';

class FormProfile extends StatefulWidget{

  String _user_id;
  bool _myProfile;

  FormProfile(){
    _myProfile = true;
  }

  FormProfile.user_id(String user_id) {
    _user_id = user_id;
    _myProfile = false;
  }

  @override
  State<StatefulWidget> createState() {
    return FormProfileState(_user_id, _myProfile);
  }
}

class FormProfileState extends State<FormProfile> {

  FormProfileState(String user_id, bool myProfile) {
    _user_id = user_id;
    _myProfile = myProfile;
  }

  var _usualTextStyle = TextStyle(fontSize: 16, color: Colors.black);
  var _errorTextStyle = TextStyle(fontSize: 22, color: Colors.red);
  var _successTextStype = TextStyle(fontSize: 22, color: Colors.green);

  String _user_id;
  bool _myProfile;

  ModelUser user = new ModelUser.empty();

  _getUserInformation(){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Builder(builder: (value){
            if (user.blocked) {
              return Text("Пользователь заблокирован до " + user.blockDate, style: _errorTextStyle);
            } else {
              return Text("Пользователь не заблокирован", style: _successTextStype); 
            }          
          },
          ),
          Text("Фамилия: " + user.surname, style: _usualTextStyle),
          Text("Имя: " + user.user_name, style: _usualTextStyle),
          Text("Отчество: " + user.surname, style: _usualTextStyle),
          Text("Дата рождения: " + user.date, style: _usualTextStyle),
          Text("Email: " + user.email, style: _usualTextStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Builder(
          builder: (value){
            if (_myProfile){
              return FutureBuilder(
                future: RestApi.getProfileResponse(),
                builder: (context, snapshot) {
                  if (snapshot.hasData ) {
                    if (snapshot.data["success"]) {
                      user = ModelUser.fromJson(snapshot.data["data"]);
                      return _getUserInformation();
                    } else {
                      return Text(snapshot.data["message"]);
                    }              
                  } else {
                    return Center(
                        child: CircularProgressIndicator());
                    };            
                },          
            );
            } else {
              return FutureBuilder(
                  future: RestApi.getUserResponse(_user_id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData ) {
                      if (snapshot.data["success"]) {
                        user = ModelUser.fromJson(snapshot.data["data"]);
                        return _getUserInformation();
                      } else {
                        return Text(snapshot.data["message"]);
                      }              
                    } else {
                      return Center(
                          child: CircularProgressIndicator());
                      };            
                  },          
              );
            }            
          },
        )
      ),
    );
  }
}