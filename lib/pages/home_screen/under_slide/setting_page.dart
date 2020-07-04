import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner:false,
      home: SettingPage(),
    ));

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Color orange_color = Color(0xFFF95E21);
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
            title: Text('Settings', style: TextStyle(fontSize:22),),
            backgroundColor: orange_color),
        body: Column(children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change Password", style: TextStyle(fontSize:20, color:Colors.grey[700])),
                  // Icon(Icons.arrow_forward_ios),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                     onPressed: (){
                      Navigator.pushNamed(context, '/change_password_page');

                     })
                  
                  
                  ]),
             ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              decoration: BoxDecoration(color: Color(0xffcccccc))),
          Container(
              padding: EdgeInsets.only(left: 15, top: 8, bottom: 0, right: 0),
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Notifications", style: TextStyle(fontSize:20, color:Colors.grey[700])),
                    Switch(
                        activeColor: orange_color,
                        value: isSwitched,
                        
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        })
                  ])),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              decoration: BoxDecoration(color: Color(0xffcccccc))),
        ]));
  }
}