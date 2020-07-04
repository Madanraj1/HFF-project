import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';



class Completedorders extends StatelessWidget {

  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  Color card_black = Color(0xFF423F3F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders'),
        backgroundColor: orange_color,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/home_page');
          },
        ),
        elevation: 5,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            child: Material(
              borderRadius:BorderRadius.circular(5) ,
              elevation: 10,
                          child: Column(
                children: <Widget>[
                  Container(
                    color: card_black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8),
                          height:40,
                          child: Text(
                            'Order No:#12344',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '09/02/2020',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontFamily: 'Roboto-Regular'
                                      ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '05:00 pm',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:Colors.white,
                                      fontFamily: 'Roboto-Regular'
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'John Deo',
                                        style: TextStyle(
                                            color: orange_color,
                                            fontFamily: 'Roboto-Bold',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '+91 12345 6789',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Roboto-Regular',
                                      ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                        fontFamily: 'Roboto-Bold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 190,
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectuer adipiscing elit, sed do elusmod tempor incididunt',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Roboto-Regular'
                                        ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Distance',
                                    style: TextStyle(
                                      fontFamily: 'Roboto-Bold',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                        ),
                                        Text(
                                          '14 km',
                                          style: TextStyle(
                                              color: orange_color,
                                              fontFamily: 'Roboto-Regular',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'to the destination',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Roboto-Regular',
                                            // fontWeight: FontWeight.w500,`
                                            ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.black),
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                
                                DottedBorder(
                                   borderType: BorderType.Rect,
                                   dashPattern: [5, 5, 5, 5],
                                    // padding: EdgeInsets.all(10),
      
                                    child: ClipRRect(
                                      child: Container(
                                        height: 70,
                                        width: 120,
      
                                        child: Column(
                                        children: <Widget>[

                                          Text('Payment method',
                                          style: TextStyle(
                                            fontFamily: 'Roboto-Bold',
                                            // fontWeight: FontWeight.bold
                                          ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(50.0,10.0, 0, 0),
                                            child: Image.asset('assets/images/Google-Pay 1.png',
                                            height: 30.0,
                                            ),
                                          )
                                        ],
                                        ),
                                      ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          
                          Container(
                            margin: EdgeInsets.fromLTRB(0,25,0,20),
                            child: RaisedButton(
                              onPressed: () {
                                
                               
                                Navigator.pushNamed(context, '/completed_order_detail');

                              },
                              child: Text(
                                'View Details',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: green_color,
                            ),
                          )
                        ],
                      ),
                    ],
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