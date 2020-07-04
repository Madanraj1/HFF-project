import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  Color orange_color = Color(0xFFF95E21);
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 1, 8.0, 1),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.grey[200], width: 3))),
        child: InkWell(
          splashColor: orange_color,
          child: Container(
            height: 50,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  size: 30,
                  color: orange_color,
                ),
                SizedBox(
                  width: 17,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Roboto-Thin',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
