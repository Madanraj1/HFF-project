import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:homely_fresh_food/pages/ordersdetails/activeOrderDetail.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveOrderList extends StatefulWidget {
  @override
  _ActiveOrderListState createState() => _ActiveOrderListState();
}

class _ActiveOrderListState extends State<ActiveOrderList> {
  Color titleBarColor = Color(0xFFE5E5E5);
  Color greenColor = Color(0xFF9AC632);
  Color orangeColor = Color(0xFFF95E21);
  Color cardBlack = Color(0xFF423F3F);
  Color darkWhite = Colors.white;
  Color lightWhite = Color(0xFFd4d2d2);
  Map apiData;
  Map distances;
  bool _isLoading = true;
  Map _statusResponse;

//to update the status to active orders by clicking on 'Remove'
  Future updateToActiveStatus(String assignee_id, String status) async {
    Map data = {'assignee_id': assignee_id, 'status': status};
    String baseUrl = 'http://hff.nyxwolves.xyz/api/status-update';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    Response response = await http.post(
      baseUrl,
      body: data,
      headers: <String, String>{'authorization': basicAuth},
    );
    _statusResponse = json.decode(response.body);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    print(_statusResponse);
  }

// to calculate the distance in kilometers
  Future getDistance(fdata, lat, lng) async {
    List distances = [];
    for (int i = 0; i < fdata['data'].length; i++) {
      Map test = fdata['data'][i]["address"];
      if (test["latitude"] != null && test['longitude'] != null) {
        var distanceInMeters = await Geolocator().distanceBetween(lat, lng,
            double.parse(test["latitude"]), double.parse(test["longitude"]));
        distances.add(distanceInMeters);
      } else {
        var empty = '-';
        distances.add(empty);
      }
    }
    return distances;
  }

// to get the data of active orders
  Future<String> getActiveOrders() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/my-orders/Activated';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double myLongitude = position.longitude;
    double mylatitude = position.latitude;
    apiData = json.decode(response.body);

    var dist = await getDistance(apiData, mylatitude, myLongitude);

    setState(() {
      apiData = json.decode(response.body);
      distances = {"distance": dist};
      print(distances);
      _isLoading = false;
    });
    // print(distances['distance'][0]);
  }

  @override
  void initState() {
    super.initState();
    getActiveOrders();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
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
              var postalCode = apiData['data'][index]['address']['postelcode'];
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
              var distance = distances['distance'][0];
              var finalDistance =
                  distance != '-' ? (distance / 1000).round() : '--';
              int assignee_id = apiData['data'][index]['assignee_id'];

              // print(finalDistance);
              // when the user clicks on the remove btn its status get updated as assigned
              void _showDialog() {
                // flutter defined function
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text(
                        "Remove This Order",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        Container(
                            height: 28,
                            width: 110,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: greenColor,
                              child: Text(
                                'Confirm',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              onPressed: () {
                                updateToActiveStatus(
                                    assignee_id.toString(), 'Assigned');
                              },
                            )),

                        FlatButton(
                          child: new Text(
                            "Close",
                            style: TextStyle(color: orangeColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }

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
                                        padding:
                                            EdgeInsets.fromLTRB(30.0, 0, 0, 0),
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
                                        height:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                220,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 0, 0, 0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 20.0, 0, 0),
                                                  child: Text(
                                                    name,
                                                    style: TextStyle(
                                                      color: orangeColor,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto-Bold',
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5.0, 0, 0),
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 20.0, 0, 0),
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5.0, 0, 0),
                                                  child: Text(
                                                    '$doorno $street  $city $postalCode ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11.0,
                                                        fontFamily:
                                                            'Roboto-Regular'),
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10.0, 0, 0),
                                                  child: Text(
                                                    'Distance ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontFamily:
                                                            'Roboto-Bold',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),

                                                // after distance
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.location_on,
                                                          ),
                                                          // this is distance
                                                          Text(
                                                            '$finalDistance KM',
                                                            // snapshot.data.distances[index],
                                                            style: TextStyle(
                                                              color:
                                                                  orangeColor,
                                                              fontFamily:
                                                                  'Roboto-Bold',
                                                              fontSize: 11.0,
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    3, 0, 0, 0),
                                                            child: Text(
                                                              'to  destination',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      11.0,
                                                                  fontFamily:
                                                                      'Roboto-Regular'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]),
                                        )),
                                  ],
                                ),

                                // right column of card
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width -
                                                170,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                260,
                                        color: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0.0, 6, 0),
                                                  child: DottedBorder(
                                                    borderType: BorderType.Rect,
                                                    dashPattern: [5, 5, 5, 5],
                                                    padding: EdgeInsets.all(10),
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
                                                      0, 20, 0, 0),
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
                                                                        ActiveOrderDetail(
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
                                                                          distance:
                                                                              finalDistance,
                                                                          assignee_id:
                                                                              assignee_id,
                                                                        )));
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0),
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
                                                        color: cardBlack,
                                                        child: Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                              fontSize: 18.0),
                                                        ),
                                                        onPressed: () {
                                                          _showDialog();
                                                        },
                                                      )),
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
            });
  }
}
