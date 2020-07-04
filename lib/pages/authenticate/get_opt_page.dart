import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class EnterOtpPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
  Color orange_color = Color(0xFFF95E21);
  Color green_color = Color(0xFF9AC632);



    return Scaffold(

      appBar: AppBar(
        title: Text("OTP Verification"),
        backgroundColor: orange_color,
      ),

      body: Column(

        children: <Widget>[


        Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Verifying your number!',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ), 
       ), 

        Text('We have sent OTP to your mobile'),
        
        SizedBox( height: 20.0, ),
        Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PinEntryTextField(
            showFieldAsBox: false,
            onSubmit: (String pin){
              
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text("Pin"),
                      content: Text('Pin entered is $pin'),
                    );
                  }
              ); //end showDialog()

            }, // end onSubmit
          ), // end PinEntryTextField()
        ), // end Padding()
      ), // end Container()

      FlatButton(
        textColor: green_color,
         child: Text(
          'Resend OTP ?',
          style: TextStyle(fontSize: 15),
        ),
        onPressed: () {
           Navigator.pushNamed(context, '/verification_page');
         },
          )


        ],

      ),
      
      
      
    );
  }
}

