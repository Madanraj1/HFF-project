import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/authenticate/signin.dart';
import 'package:homely_fresh_food/pages/home_screen/custom_list_tile.dart';
import 'package:homely_fresh_food/pages/home_screen/empty-assigned-orders.dart';
import 'package:homely_fresh_food/pages/ordersdetails/activeOrderList.dart';
import 'package:homely_fresh_food/pages/ordersdetails/assignedOrderList.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homely_fresh_food/modals/profile.dart';
import 'package:homely_fresh_food/services/profile_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  Color title_bar_color = Color(0xFFE5E5E5);
  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  Color card_black = Color(0xFF423F3F);
  Color dark_white = Colors.white;
  Color light_white = Color(0xFFd4d2d2);
  Map assignedApiData;
  Map activeApiData;
  bool _isLoading1 = true;
  bool _isLoading2 = true;
  var assignedOrders;
  var activeOrders;

// using this api to show the quantity of orders in badges

  Future<String> getActiveOrders() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/my-orders/Activated';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    setState(() {
      activeApiData = json.decode(response.body);
      activeOrders = activeApiData['data'].length;
      _isLoading2 = false;
    });
  }

  Future<String> getAssignedOrders() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/my-orders';
    sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    setState(() {
      assignedApiData = json.decode(response.body);
      assignedOrders = assignedApiData['data'].length;
      _isLoading1 = false;
    });
  }

  @override
  initState() {
    super.initState();
    checkLoginStatus();
    getAssignedOrders();
    getActiveOrders();
  }

// when logging out clear the token
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Signin()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/HFF_Logo.png'),
          backgroundColor: title_bar_color,
          iconTheme: new IconThemeData(color: orange_color),
          bottom: TabBar(
            unselectedLabelColor: light_white,
            labelColor: dark_white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: _isLoading1 == true
                    ? LinearProgressIndicator(
                        backgroundColor: orange_color,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: orange_color,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Badge(
                              badgeContent: Text(
                                //number of order in a tab
                                '${assignedOrders}',
                                style: TextStyle(color: dark_white),
                              ),
                              child: Text(
                                "Assigned Orders",
                              )),
                        )),
              ),
              Tab(
                child: _isLoading2 == true
                    ? LinearProgressIndicator(
                        backgroundColor: orange_color,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.horizontal(),
                          // border: Border.all(color: Colors.redAccent, width: 1),
                          color: orange_color,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Badge(
                              badgeContent: Text(
                                // numbers fo  orders in a tab
                                '${activeOrders}',
                                style: TextStyle(color: dark_white),
                              ),
                              child: Text(
                                "Active Orders",
                              )),
                        )),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                MdiIcons.calendarMonth,
                color: orange_color,
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/pusher_notification');
                Navigator.pushNamed(context, '/calendar_page');
              },
            ),
            IconButton(
              icon: Icon(
                MdiIcons.bell,
                color: orange_color,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notification_page');
              },
            )
          ],
        ),
        drawer: Drawer(
          // callimg the profile modal class and getprofiledata function from the profile service to display name and email in the drawer
          child: FutureBuilder<Profile>(
            future: getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                  child: Text('Loading'),
                ));
              } else {
                return ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 43,
                              backgroundColor: orange_color,
                              child: FadeInImage.assetNetwork(
                                  //  height: 30,
                                  placeholder: "assets/images/loading.png",
                                  image: snapshot.data.data.profilePicture),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              snapshot.data.data.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              snapshot.data.data.email,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Roboto-Thin',
                              ),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[
                        Colors.deepOrangeAccent,
                        Colors.deepOrange
                      ])),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              CustomListTile(Icons.person_outline, 'Profile',
                                  () {
                                Navigator.pushNamed(context, '/profile_page');
                              }),
                              CustomListTile(Icons.check_circle_outline,
                                  'Completed Orders', () {
                                Navigator.pushNamed(context, '/completed_page');
                              }),
                              CustomListTile(
                                  Icons.settings_applications, 'Settings', () {
                                Navigator.pushNamed(context, '/setting_page');
                              }),
                              CustomListTile(MdiIcons.accountCircleOutline,
                                  'Support Us', () {}),
                              CustomListTile(MdiIcons.exitToApp, 'Log Out', () {
                                // removing the token
                                sharedPreferences.clear();
                                sharedPreferences.commit();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Signin()),
                                    (Route<dynamic> route) => false);
                              }),
                            ],
                          ),
                          Container(
                            child: Image.asset(
                              'assets/images/bikeguy.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        body: TabBarView(
          children: [
            //card starts from here
            Container(
              child: assignedOrders != 0
                  ? AssignedOrderList()
                  : EmptyAssignedOrders(),
            ),

            //     // AssignedOrderList()
            //     // EmptyAssignedOrders(),

            Container(
              child:
                  activeOrders != 0 ? ActiveOrderList() : EmptyAssignedOrders(),
            ),
          ],
        ),
      ),
    );
  }
}
