import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:homely_fresh_food/pages/ordersdetails/completed_order_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedOrderList extends StatefulWidget {
  @override
  _CompletedOrderListState createState() => _CompletedOrderListState();
}

class _CompletedOrderListState extends State<CompletedOrderList> {
  Color titleBarColor = Color(0xFFE5E5E5);
  Color greenColor = Color(0xFF9AC632);
  Color orangeColor = Color(0xFFF95E21);
  Color cardBlack = Color(0xFF423F3F);
  Color darkWhite = Colors.white;
  Color lightWhite = Color(0xFFd4d2d2);
  bool _isLoading = true;
  Map apiData;

  Future<String> getCompletedOrders() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/my-orders/Delivered';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});

    setState(() {
      apiData = json.decode(response.body);
      _isLoading = false;
    });
    // print(distances['distance'][0]);
  }

  @override
  void initState() {
    super.initState();
    getCompletedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders'),
        backgroundColor: orangeColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/home_page');
          },
        ),
        elevation: 5,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: apiData['data'].length,
              itemBuilder: (context, index) {
                //storing all the needed data of the api in the variables
                var orderNo = apiData['data'][index]['order_id'];
                var date = apiData['data'][index]['dates'];
                var time = apiData['data'][index]['timeslot'];
                var amount = apiData['data'][index]['amount'];
                var phone = apiData['data'][index]['user']['phone'];
                var name = apiData['data'][index]['user']['name'];
                var doorno = apiData['data'][index]['address']['doorno'];
                var street = apiData['data'][index]['address']['street'];
                var city = apiData['data'][index]['address']['city'];
                var postalCode =
                    apiData['data'][index]['address']['postelcode'];
                var address = '$doorno $street  $city  $postalCode';
                var oneprice = apiData['data'][index]['plan']['one_price'];
                var foodPicture = apiData['data'][index]['plan']['picture'];
                var menuTitle01 =
                    apiData['data'][index]['plan']['menus'][0]['title'];
                var menuDescription01 =
                    apiData['data'][index]['plan']['menus'][0]['description'];
                var menuTitle02 =
                    apiData['data'][index]['plan']['menus'][1]['title'];
                var menuDescription02 =
                    apiData['data'][index]['plan']['menus'][1]['description'];
                var deliveryStatus = apiData['data'][index]['delivery_status'];

                // print(finalDistance);
                // when the user clicks on the remove btn its status get updated as assigned

                return Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.width - 370,
                                width: MediaQuery.of(context).size.width - 10,
                                color: cardBlack,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 0, 0, 0),
                                      child: Text(
                                        'Order No ${orderNo}',
                                        style: TextStyle(
                                          color: darkWhite,
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto-Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              30.0, 0, 0, 0),
                                        ),
                                        Icon(
                                          MdiIcons.calendarWeek,
                                          color: darkWhite,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              6.0, 0, 0, 0),
                                          child: Text(
                                            //date
                                            date,
                                            style: TextStyle(
                                              color: darkWhite,
                                              fontSize: 11.0,
                                              fontFamily: 'Roboto-Regular',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 0, 0, 0),
                                          child: Icon(
                                            MdiIcons.clock,
                                            color: darkWhite,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              6.0, 0, 0, 0),
                                          child: Text(
                                            //time
                                            time,
                                            style: TextStyle(
                                              color: darkWhite,
                                              fontSize: 10.0,
                                              fontFamily: 'Roboto-Regular',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // after black part of card
                              Row(
                                children: <Widget>[
                                  // left column of card
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              220,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 20, 0, 0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0, 20.0, 0, 0),
                                                    child: Text(
                                                      name,
                                                      style: TextStyle(
                                                        color: orangeColor,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Roboto-Bold',
                                                      ),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 5.0, 0, 0),
                                                    child: Text(
                                                      phone,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0,
                                                          fontFamily:
                                                              'Roboto-Regular'),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0, 50.0, 0, 0),
                                                    child: Text(
                                                      'Address ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              'Roboto-Bold',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 5.0, 0, 0),
                                                    child: Text(
                                                      '$doorno $street  $city $postalCode ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11.0,
                                                          fontFamily:
                                                              'Roboto-Regular'),
                                                    ),
                                                  ),

                                                  // Padding(
                                                  //   padding: const EdgeInsets
                                                  //           .fromLTRB(
                                                  //       0, 10.0, 0, 0),
                                                  //   child: Text(
                                                  //     'Distance ',
                                                  //     style: TextStyle(
                                                  //         color: Colors.black,
                                                  //         fontSize: 18.0,
                                                  //         fontFamily:
                                                  //             'Roboto-Bold',
                                                  //         fontWeight:
                                                  //             FontWeight.bold),
                                                  //   ),
                                                  // ),

                                                  // // after distance
                                                  // Padding(
                                                  //   padding: const EdgeInsets
                                                  //       .fromLTRB(0, 0, 0, 0),
                                                  //   child: Column(
                                                  //     children: <Widget>[
                                                  //       Row(
                                                  //         children: <Widget>[
                                                  //           Icon(
                                                  //             Icons.location_on,
                                                  //           ),
                                                  //           // this is distance
                                                  //           Text(
                                                  //             ' KM',
                                                  //             // snapshot.data.distances[index],
                                                  //             style: TextStyle(
                                                  //               color:
                                                  //                   orangeColor,
                                                  //               fontFamily:
                                                  //                   'Roboto-Bold',
                                                  //               fontSize: 11.0,
                                                  //             ),
                                                  //           ),

                                                  //           Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                         .fromLTRB(
                                                  //                     3,
                                                  //                     0,
                                                  //                     0,
                                                  //                     0),
                                                  //             child: Text(
                                                  //               'to  destination',
                                                  //               style: TextStyle(
                                                  //                   fontSize:
                                                  //                       11.0,
                                                  //                   fontFamily:
                                                  //                       'Roboto-Regular'),
                                                  //             ),
                                                  //           ),
                                                  //         ],
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // )
                                                ]),
                                          )),
                                    ],
                                  ),

                                  // right column of card
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 0, 0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              170,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              260,
                                          color: Colors.white,
                                          child: Column(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0.0, 6, 0),
                                                    child: DottedBorder(
                                                      borderType:
                                                          BorderType.Rect,
                                                      dashPattern: [5, 5, 5, 5],
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12)),
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              340,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              170,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Payment Method'),
                                                              Image.asset(
                                                                'assets/images/razor-pay.jpg',
                                                                height: 30.0,
                                                              ),
                                                              Text(
                                                                amount,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 50, 0, 0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              370,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              280,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: RaisedButton(
                                                        textColor: Colors.white,
                                                        color: greenColor,
                                                        child: Text(
                                                          'View Order',
                                                          style: TextStyle(
                                                              fontSize: 16.0),
                                                        ),
                                                        onPressed: () {
                                                          // Navigator.pushNamed(context, '/order_detail_confirm');
                                                          // Navigator.pushNamed(context, '/order_detail_delivered');
                                                          // Navigator.pushNamed(context, '/order_detail_pickup');

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          OrderdetailsDelivered(
                                                                            // passing the data to show it on the detail  page the detail page is orderdetails/order_detail_page_delivered.dart
                                                                            orderNo:
                                                                                orderNo,
                                                                            date:
                                                                                date,
                                                                            time:
                                                                                time,
                                                                            phone:
                                                                                phone,
                                                                            name:
                                                                                name,
                                                                            address:
                                                                                address,
                                                                            amount:
                                                                                amount,
                                                                            onePrice:
                                                                                oneprice,
                                                                            foodPicture:
                                                                                foodPicture,
                                                                            menuTitle01:
                                                                                menuTitle01,
                                                                            menuDescription01:
                                                                                menuDescription01,
                                                                            menuTitle02:
                                                                                menuTitle02,
                                                                            menuDescription02:
                                                                                menuDescription02,
                                                                          )));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
    );
  }
}
