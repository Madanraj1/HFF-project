import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  @override
  _Signin_State createState() => _Signin_State();
}

// login with basic auth key
class _Signin_State extends State<Signin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String message;

  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  Color title_bar_color = Color(0xFFE5E5E5);

  signIn(String email, String password) async {
    // to store the basic auth key  and when logging out clear the key
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': password};

    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$email:$password'));
    // print('token key $basicAuth');
    // print('$email $password');
    Response response = await http.post(
      'http://hff.nyxwolves.xyz/api/login',
      body: data,
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200) {
      print(response.statusCode);
      message = 'success';
      setState(() {
        _isLoading = false;
      });
      // to store the token value in the instance
      sharedPreferences.setString("token", basicAuth);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    } else {
      print(response.statusCode);
      message = 'Invalid credentials';
      setState(() {
        _isLoading = false;
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: title_bar_color,
        appBar: AppBar(
          title: Image.asset('assets/images/HFF_Logo.png'),
          backgroundColor: Colors.grey[100],
          elevation: 2.0,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(40),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Welcome to your HFF Account',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 35),
                        )),

                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(),
                          labelText: 'Email or Mail ID ',
                          suffixIcon: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              child: Icon(
                                Icons.email,
                                color: orange_color,
                              )),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(end: 12.0),
                            child: Icon(
                              Icons.lock,
                              color: orange_color,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    // showing the error
                    message == null
                        ? Container()
                        : Text(
                            '$message',
                            style: TextStyle(color: orange_color),
                          ),

                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot_password_page');
                      },
                      textColor: Colors.black,
                      child: Text('Forgot Password'),
                    ),

                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(85, 0, 85, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: green_color,
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            signIn(nameController.text.trim(),
                                passwordController.text);
                          },
                        )),

                    Container(
                        child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: green_color,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.pushNamed(context, '/signup');
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
                  ],
                )));
  }
}
