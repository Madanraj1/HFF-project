import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _Signup_state createState() => _Signup_state();
}

class _Signup_state extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController driverlicenceController = TextEditingController();

  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);

// to store the error or success message
  Map _returnJsonData;

  var display_error;
//to show the loading screen
  bool _isLoading = false;
// agreeing terms and conditions
  bool _isSelected = false;

  createUser(
    String name,
    String phone,
    String email,
    String password,
    String licencenumber,
  ) async {
    Map data = {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'licencenumber': licencenumber
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = 'Basic' + base64Encode(utf8.encode('$email:$password'));
// print(basicAuth);

    Response response = await http.post(
      'http://hff.nyxwolves.xyz/api/register',
      body: data,
      headers: <String, String>{'authorization': basicAuth},
    );
    _returnJsonData = jsonDecode(response.body);
// print(response.body);

    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;
      });
      sharedPreferences.setString("token", basicAuth);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      display_error = _returnJsonData['errors'];
      // print(display_error);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.black),
              )
            : Container(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Register',
            style: TextStyle(
              fontSize: 28.0,
            ),
          ),
          backgroundColor: orange_color,
          elevation: 2.0,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: ListView(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Lets Create your HFF Account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 35),
                            )),

                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12.0),
                                child: Icon(MdiIcons.face, color: orange_color),
                              ),
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'FullName is required';
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              labelText: 'Email Address',
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12.0),
                                child: Icon(
                                  MdiIcons.emailBox,
                                  color: orange_color,
                                ), // myIcon is a 48px-wide widget.
                              ),
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'Email is required';
                              }
                            },
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: phonenumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              labelText: 'Mobile number ',
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12.0),
                                child: Icon(
                                  MdiIcons.phone,
                                  color: orange_color,
                                ), // myIcon is a 48px-wide widget.
                              ),
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'PhoneNumber is required';
                              }
                            },
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              labelText: 'Password',
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12.0),
                                child: Icon(
                                  MdiIcons.lock,
                                  color: orange_color,
                                ), // myIcon is a 48px-wide widget.
                              ),
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'Password is required';
                              }
                            },
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            obscureText: true,
                            controller: confirmpasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12.0),
                                child: Icon(
                                  MdiIcons.checkboxMarkedCircleOutline,
                                  color: orange_color,
                                ), // myIcon is a 48px-wide widget.
                              ),
                            ),
                            validator: (String value) {
                              if (value != passwordController.text) {
                                return 'The password did not match';
                              }
                            },
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: driverlicenceController,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(),
                              labelText: 'Enter Driving Licence number',
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12.0),
                                child: Icon(
                                  MdiIcons.fileAccountOutline,
                                  color: orange_color,
                                ), // myIcon is a 48px-wide widget.
                              ),
                            ),
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'Driving Licence Number is required';
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: _radio,
                              child: radioButton(_isSelected),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                                "By Register  you accept the Terms of Service and Privacy Policy.",
                                style: TextStyle(
                                    fontSize: 10, fontFamily: "Poppins-Medium"))
                          ],
                        ),

                        SizedBox(height: 20.0),
                        // to show the error
                        display_error == null
                            ? Container()
                            : Text(
                                '$display_error',
                                style: TextStyle(color: orange_color),
                              ),

                        Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(85, 0, 85, 10),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: green_color,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate() &&
                                    _isSelected == true) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  createUser(
                                      nameController.text,
                                      phonenumberController.text,
                                      emailController.text,
                                      passwordController.text,
                                      driverlicenceController.text);
                                } else {
                                  setState(() {
                                    display_error =
                                        'Accept all the terms and conditions';
                                  });
                                }
                              },
                            )),
                      ],
                    )),
              ));
  }
}
