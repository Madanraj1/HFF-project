import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

TextEditingController oldpasswordController = TextEditingController();
TextEditingController newpasswordController = TextEditingController();
  Color orange_color = Color(0xFFF95E21);
  Color green_color = Color(0xFF9AC632);
  var _returnJsondata;
  var message;

changePassword(String oldpassword, String newpassword) async {
Map data ={
  'old_password' : oldpassword,
  'new_password': newpassword,
};
String baseUrl = 'http://hff.nyxwolves.xyz/api/change-password';
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
String basicAuth = sharedPreferences.getString("token");
Response response = await http.post(baseUrl, body:data,
headers: <String, String>{'authorization': basicAuth},
 );
 print(data);
 _returnJsondata = jsonDecode(response.body);
print(_returnJsondata);
 if( response.statusCode == 201){
   print(response.statusCode);
   message = 'Password changed';
     oldpasswordController.clear();
      newpasswordController.clear();
 } else {
   message = _returnJsondata;
 }


}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: orange_color,
      ),


      body: SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
         
          Center(
            child: Container(
                      child: Image.asset(
                'assets/images/key.png'
              ),
            ),
          ),


          Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
          child: Container(
            height: 300.0,
                    child: Card(
              elevation: 10.0,
              
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    
                    Text(
                      'Change Your ',
                      style: TextStyle(
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    
                     Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    Container(
                      // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: oldpasswordController,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(),
                          labelText: 'Old Password',
                           suffixIcon: Padding(
                           padding: const EdgeInsetsDirectional.only(end: 12.0),
                          child: Icon(MdiIcons.lock,
                                            color: orange_color,
                          ), // myIcon is a 48px-wide widget.
                          ),
                        ),
                      ),
                    ),

                      Container(
                      // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: newpasswordController,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(),
                          labelText: 'New Password',
                           suffixIcon: Padding(
                           padding: const EdgeInsetsDirectional.only(end: 12.0),
                          child: Icon(MdiIcons.checkboxMarkedCircleOutline,
                                            color: orange_color,
                          ), // myIcon is a 48px-wide widget.
                          ),
                        ),
                      ),
                    ),
                message == null  ? Container(): Text(message, style: TextStyle(color: orange_color),),

                   
                     Padding(
                       padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                       child: RaisedButton(
                        textColor: Colors.white,
                        color: green_color,
                        child: Text('Done',
                          style: TextStyle(
                             fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          changePassword(oldpasswordController.text, newpasswordController.text);
                          // Navigator.popAndPushNamed(context, '/change_password_page');
                        
                        },
                    ),
                     ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
    ),

        
   

         
        ],
        ),
      ),
      
    );
  }
}

