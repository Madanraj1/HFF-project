
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Otp_Screen extends StatefulWidget {
  @override
  _Otp_ScreenState createState() => _Otp_ScreenState();
}

class _Otp_ScreenState extends State<Otp_Screen> {
  @override
  Widget build(BuildContext context) {
 
    List<Widget> widgetList = [

    ];
  Color orange_color = Color(0xFFF95E21);


    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.red,
        //   title: Text("Login", style: TextStyle(
        //     color: Colors.white,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   ),
        // ),
        backgroundColor: Color(0xFFeaeaea),
        body:Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
          child: ListView(
           shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 20.0, right: 16.0),
                  child: Text("We need to text your OTP to authenticate your account",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,),
                ),

              SizedBox( height: 20.0, ),
               

                Row(
                  children: <Widget>[

                    Flexible(
                      child: new Container(
                      ),
                      flex: 1,
                    ),

                    Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.center,
                        autofocus: true,
                        enabled: false,
                        initialValue: "+91",
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                        decoration: InputDecoration(
                        labelText: '  (India)',
                          
                        ),
                        
                      ),
                      flex: 3,
                    ),

                    Flexible(
                      child: new Container(
                      ),
                      flex: 1,
                    ),

                    Flexible(
                      child: new TextFormField(
                        textAlign: TextAlign.start,
                        
                        autofocus: false,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        suffixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        child: Icon(MdiIcons.phone,
                                    color: orange_color,
                                  ), // myIcon is a 48px-wide widget.
                  ),
                          
                        ),
                        style: TextStyle(fontSize: 20.0, color: Colors.black
                        
                        ),
                      ),
                      flex: 9,
                    ),

                    Flexible(
                      child: new Container(
                      ),
                      flex: 1,
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                  child: new Container (
                    width: 150.0,
                    height: 40.0,
                    child: new RaisedButton(onPressed: () {
                      Navigator.of(context).pushNamed('/get_otp_page');
                    },
                        child: Text("Get OTP narpet"),
                        textColor: Colors.white,
                        color: orange_color,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))
                    ),
                  ),
                )
              ]
          )],),
        )
    );


  }
}