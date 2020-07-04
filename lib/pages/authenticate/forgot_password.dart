import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController nameController = TextEditingController();
  Color orange_color = Color(0xFFF95E21);
  Color green_color = Color(0xFF9AC632);
  Map json_response;
  var message;

// i don't think i have to explain this function to you
  forgotPassword(String email) async {
    Map data = {
      'email': email,
    };
    String baseUrl = 'http://hff.nyxwolves.xyz/api/reset-password';
    var response = await http
        .post(baseUrl, body: data, headers: {'Accept': 'application/json'});
    json_response = json.decode(response.body);
    if (response.statusCode == 201) {
      setState(() {
        message = json_response['message'];
      });
    } else {
      setState(() {
        message = json_response['message'];
      });
    }
    print(json_response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: orange_color,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Center(
                child: Container(
                  child: Image.asset('assets/images/lock.png'),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 80, 30.0, 0.0),
                child: Container(
                  height: 300.0,
                  child: Card(
                    elevation: 10.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Forgot Your ',
                            style: TextStyle(
                                fontSize: 38.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 38.0, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Email or Mail ID ',
                                suffixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      end: 12.0),
                                  child: Icon(
                                    Icons.email,
                                    color: orange_color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          message != null
                              ? Container(
                                  child: Text(
                                    '$message',
                                    style: TextStyle(color: orange_color),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: green_color,
                              child: Text(
                                'Send',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              onPressed: () {
                                forgotPassword(nameController.text);
                                nameController.clear();
                                FocusScope.of(context).unfocus();
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
