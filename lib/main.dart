import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/authenticate/change_password.dart';
import 'package:homely_fresh_food/pages/authenticate/forgot_password.dart';
import 'package:homely_fresh_food/pages/authenticate/get_opt_page.dart';
import 'package:homely_fresh_food/pages/authenticate/otp_page.dart';
import 'package:homely_fresh_food/pages/authenticate/signin.dart';
import 'package:homely_fresh_food/pages/authenticate/signup.dart';
import 'package:homely_fresh_food/pages/authenticate/verification_pending.dart';
import 'package:homely_fresh_food/pages/home_screen/calender_page.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:homely_fresh_food/pages/home_screen/no_notification.dart';
import 'package:homely_fresh_food/pages/home_screen/notification_page.dart';
import 'package:homely_fresh_food/pages/home_screen/pusher_notification.dart';
import 'package:homely_fresh_food/pages/home_screen/under_slide/profile.dart';
import 'package:homely_fresh_food/pages/home_screen/under_slide/setting_page.dart';
import 'package:homely_fresh_food/pages/ordersdetails/assignedOrderDetail.dart';
import 'package:homely_fresh_food/pages/ordersdetails/compelted_order_list.dart';
import 'package:homely_fresh_food/pages/ordersdetails/activeOrderDetail.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => Signin(),
        '/signin': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/otp_screen': (context) => Otp_Screen(),
        '/get_otp_page': (context) => EnterOtpPage(),
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
        '/pusher_notification': (context) => PusherNotification(),
      },
    );
  }
}
