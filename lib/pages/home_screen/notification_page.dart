import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/home_screen/no_notification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  bool _isLoading = true;
  List apiNotifications;

  Future<void> getNotifications() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/notifications';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    setState(() {
      apiNotifications = json.decode(response.body);
      print(apiNotifications);
      _isLoading = false;
    });
  }

  Future<void> markAsRead(String id) async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/notification-read/$id';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    Navigator.popAndPushNamed(context, '/notification_page');
  }

  Future<void> markAllAsRead() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/notification-read';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    Navigator.popAndPushNamed(context, '/notification_page');
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: orange_color,
        elevation: 20,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home_page');
          },
          color: Colors.white,
          splashColor: Colors.white,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : apiNotifications.length == 0
              ? NonotificationPage()
              : Container(
                  child: ListView.builder(
                      itemCount: apiNotifications.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
                              child: Material(
                                elevation: 10,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '${apiNotifications[index]['data']['plan_name']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto-Bold',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            splashColor: Colors.white,
                                            icon: Icon(
                                              Icons.fiber_manual_record,
                                              color: green_color,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              markAsRead(apiNotifications[index]
                                                  ['id']);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 5, 10),
                                      child: Text(
                                        '${apiNotifications[index]['data']['user_name']}  ${apiNotifications[index]['data']['email']}  ${apiNotifications[index]['data']['phoneno']}  ${apiNotifications[index]['data']['door_no']}  ${apiNotifications[index]['data']['street']}  ${apiNotifications[index]['data']['city']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Roboto-Regular',
                                            color: Color(0xFF9C9C9C)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          markAllAsRead();
        },
        child: Icon(Icons.clear_all),
        backgroundColor: orange_color,
      ),
    );
  }
}
