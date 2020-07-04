import 'package:flutter/material.dart';

class NonotificationPage extends StatelessWidget {
  Color orange_color = Color(0xFFF95E21);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // SizedBox(height:40),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    'No notifications right now',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: Image.asset('assets/images/no-notification.png'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
