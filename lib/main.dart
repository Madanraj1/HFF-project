import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/authenticate/change_password.dart';
import 'package:homely_fresh_food/pages/authenticate/forgot_password.dart';
import 'package:homely_fresh_food/pages/authenticate/otp_page.dart';
import 'package:homely_fresh_food/pages/authenticate/signin.dart';
import 'package:homely_fresh_food/pages/authenticate/signup.dart';
import 'package:homely_fresh_food/pages/authenticate/verification_pending.dart';
import 'package:homely_fresh_food/pages/home_screen/calender_page.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:homely_fresh_food/pages/home_screen/no_notification.dart';
import 'package:homely_fresh_food/pages/home_screen/notification_page.dart';
import 'package:homely_fresh_food/pages/home_screen/under_slide/profile.dart';
import 'package:homely_fresh_food/pages/home_screen/under_slide/setting_page.dart';
import 'package:homely_fresh_food/pages/ordersdetails/assignedOrderDetail.dart';
import 'package:homely_fresh_food/pages/ordersdetails/compelted_order_list.dart';
import 'package:homely_fresh_food/pages/ordersdetails/activeOrderDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // these two are used for to call now btn
  setupLocator();
  setupLocator1();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homely Fresh Food',
      debugShowCheckedModeBanner: false,
      initialRoute: '/wrapper',
      routes: {
        '/wrapper': (context) => Wrapper(),
        '/': (context) => Signin(),
        '/signin': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/otp_screen': (context) => Otp_Screen(),
        '/verification_page': (context) => VerificationPending(),
        '/change_password_page': (context) => ChangePassword(),
        '/forgot_password_page': (context) => ForgotPassword(),
        '/home_page': (context) => HomePage(),
        '/calendar_page': (context) => Calenderpage(),
        '/notification_page': (context) => NotificationPage(),
        '/no_notification_page': (context) => NonotificationPage(),
        '/profile_page': (context) => ProfilePage(),
        '/completed_page': (context) => CompletedOrderList(),
        '/setting_page': (context) => SettingPage(),
      },
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var tok = preferences.getString("token");
    if (tok != null) {
      Navigator.pushReplacementNamed(context, "/home_page");
    } else {
      Navigator.pushReplacementNamed(context, "/");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ));
  }
}
