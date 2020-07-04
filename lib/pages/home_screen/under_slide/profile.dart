import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as doi;
import 'package:flutter/material.dart';
import 'package:homely_fresh_food/modals/profile.dart';
import 'package:homely_fresh_food/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Color orange_color = Color(0xFFF95E21);
  Color pic_grey = Color(0xFFC4C4C4);
  Color green_color = Color(0xFF9AC632);
  String message;
  Map _returnjsonData;
  bool _isLoading = false;
  var _image;
  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
  }

  void _uploadPhoto(
    String name,
    String phone,
    String licencenumber,
    File file,
  ) async {
    String fileName = file.path.split('/').last;
    print('1');
    FormData data = FormData.fromMap({
      'name': name,
      'phone': phone,
      'licencenumber': licencenumber,
      "profile_picture":
          await doi.MultipartFile.fromFile(file.path, filename: fileName),
    });
    print('2');
    Dio dio = new Dio();
    String baseUrl = 'http://hff.nyxwolves.xyz/api/update-profile';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    dio.options.headers['content-Type'] = 'application/json';
    print('3');
    dio.options.headers['authorization'] = basicAuth;
    print('4');
    var response = await dio.post(baseUrl, data: data);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController licencenumberController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/home_page');
            },
          ),
          backgroundColor: orange_color,
          title: Text("Profile")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<Profile>(
              future: getProfileData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                      child: Center(
                    child: Text('Loading'),
                  ));
                } else {
                  return SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: 40, bottom: 10),
                                alignment: Alignment.center,
                                height: 110,
                                width: 115,
                                decoration: BoxDecoration(
                                  color: pic_grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FadeInImage.assetNetwork(
                                    //  height: 30,
                                    placeholder: "assets/images/loading.png",
                                    image: snapshot.data.data.profilePicture),
                              ),
                            ),
                            RaisedButton(
                              elevation: 0.0,
                              onPressed: () {
                                _choose();
                              },
                              child: Text(
                                'Upload Image',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Text(
                              _image != null
                                  ? _image.path.split('/').last.toString()
                                  : '',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),

                            SizedBox(
                              width: 350,
                              child: TextField(
                                // enabled: false,
                                controller: fullNameController,
                                style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.w800),
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.person_outline,
                                      color: orange_color),
                                  labelText: snapshot.data.data.name,
                                ),
                              ),
                            ),

                            SizedBox(
                                width: 350,
                                child: TextField(
                                    enabled: false,
                                    style: TextStyle(
                                        fontFamily: 'Roboto-Regular',
                                        fontWeight: FontWeight.w800),
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.mail,
                                            color: orange_color),
                                        labelText: snapshot.data.data.email))),

                            SizedBox(
                                width: 350,
                                child: TextField(
                                    // enabled: false,
                                    controller: phoneController,
                                    style: TextStyle(
                                        fontFamily: 'Roboto-Regular',
                                        fontWeight: FontWeight.w800),
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.call,
                                            color: orange_color),
                                        labelText: snapshot.data.data.phone))),

                            SizedBox(
                                width: 350,
                                child: TextField(
                                    // enabled: false,
                                    controller: licencenumberController,
                                    style: TextStyle(
                                        fontFamily: 'Roboto-Regular',
                                        fontWeight: FontWeight.w800),
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.description,
                                            color: orange_color),
                                        labelText:
                                            snapshot.data.data.licencenumber))),
                            // show the error
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              ' Please Fill all the Fields to  Update Profile',
                              style: TextStyle(color: orange_color),
                            ),

                            Container(
                                margin: EdgeInsets.only(top: 30),
                                width: 140,
                                child: RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _uploadPhoto(
                                        fullNameController.text,
                                        phoneController.text,
                                        licencenumberController.text,
                                        _image,
                                      );
                                    },
                                    color: green_color,
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    )))
                          ],
                        ),
                      ));
                }
              },
            ),
    );
  }
}
