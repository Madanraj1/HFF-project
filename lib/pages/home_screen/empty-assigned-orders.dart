import 'package:flutter/material.dart';

class EmptyAssignedOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
            children: <Widget>[
              SizedBox(height:40),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 40, 0, 0),
                  child: Text(
                    'You will receive your order',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                      color: Color(0xFF1A1824)
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    'soon be alert always',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Bold',
                      color: Color(0xFF1A1824)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Image.asset('assets/images/no_orders.png'),
              ),
            ],
          ),
      ),
    );
      
    
  }
}