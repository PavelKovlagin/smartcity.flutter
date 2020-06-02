import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSendCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FormSendCodeState();
}

class FormSendCodeState extends State<FormSendCode> {

  final _formKey = GlobalKey<FormState>();

  String _email = "";

  _sendCodeWidget(){
    return SingleChildScrollView(
      child: Container(
      padding: EdgeInsets.all(16.0),
        child: new Form(key: _formKey,
          child: new Column(children: <Widget>[
            new TextFormField(validator: (value){
              if (value.isEmpty) return "Введите email";
            },
              onSaved: (value) {
              _email = value;
              },
              decoration: InputDecoration( labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
        new SizedBox(height: 20.0),
        new RaisedButton(onPressed: (){              
          _formKey.currentState.save();
          if (_formKey.currentState.validate()){
            Navigator.pushNamed(context, '/changePassword/'+_email); 
          }                            
        }, child: Text('Отправить код сброса'),
          color: Colors.blue,
          textColor: Colors.white,)
      ],
      ),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text("Сброс пароля")),
        body: _sendCodeWidget()
    );
  }
}