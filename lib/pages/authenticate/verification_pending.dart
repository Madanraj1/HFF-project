import 'package:flutter/material.dart';


class VerificationPending extends StatefulWidget {
  @override
  _VerificationPendingState createState() => _VerificationPendingState();
}

class _VerificationPendingState extends State<VerificationPending> {

  
  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Verification Pending',
        ),
        backgroundColor: orange_color,
      ),
      
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
        child: Column(
          children: <Widget>[


           
            Text(
              'Your Verification is in process,',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            
            ),

            Text(
              'Our team will contact you shortly',
               style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              ),

              Image.asset(
                  'assets/images/Frame.png',
                  height: 400.0,
              ),

          ],

        ),
      ),

    );
  }
}