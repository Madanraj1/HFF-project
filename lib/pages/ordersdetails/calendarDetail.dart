import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  updateStatus() async {}
  void call(String number) => launch("tel:$number");
}

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}

final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

class CalendatDetailPage extends StatefulWidget {
  var orderId;
  CalendatDetailPage({this.orderId});

  @override
  _CalendatDetailPageState createState() => _CalendatDetailPageState();
}

class _CalendatDetailPageState extends State<CalendatDetailPage> {
  Color title_bar_color = Color(0xFFE5E5E5);
  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  Color card_black = Color(0xFF423F3F);
  Color dark_white = Colors.white;
  Color light_white = Color(0xFFd4d2d2);
  Map _statusResponse;
  var apiData;
  Map distances;
  bool _isLoading = true;

// to calculate the distance in kilometers
  Future getDistance(fdata, lat, lng) async {
    List distances = [];
    for (int i = 0; i < fdata['data'].length; i++) {
      Map test = fdata['data']["address"];
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

  Future<String> getOrderDetail() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/my-order/${widget.orderId}';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double myLongitude = position.longitude;
    double mylatitude = position.latitude;
    apiData = json.decode(response.body);
    print('this is response $apiData');
    var dist = await getDistance(apiData, mylatitude, myLongitude);

    setState(() {
      apiData = json.decode(response.body);
      distances = {"distance": dist};
      print(distances);
      _isLoading = false;
    });
    // print(distances['distance'][0]);
  }

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

  _launchURL(_url) async {
    var url = _url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    var distance = distances['distance'][0];
    var finalDistance = distance != '-' ? (distance / 1000).round() : '--';
    var delivery_status = apiData['data']['delivery_status'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: orange_color,
        elevation: 5,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Text('Order No: ${apiData['data']['order_id']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                              ),
                              SizedBox(width: 3),
                              Text('${apiData['data']['dates']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Roboto-Regular')),
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
                              ),
                              SizedBox(width: 3),
                              Text(
                                '${apiData['data']['timeslot']}',
                                style: TextStyle(
                                    fontSize: 13, fontFamily: 'Roboto-Regular'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 0,
                  thickness: 2.0,
                  color: Colors.black,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
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
                                      '${apiData['data']['user']['name']}',
                                      style: TextStyle(color: orange_color),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${apiData['data']['user']['phone']}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Roboto-Regular'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Address',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 190,
                                  child: Text(
                                      '${apiData['data']['address']['doorno']}${apiData['data']['address']['street']} ${apiData['data']['address']['city']} ',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'Roboto-Regular')),
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
                                        size: 15,
                                      ),
                                      Text(
                                        '${finalDistance} km',
                                        style: TextStyle(
                                            color: orange_color, fontSize: 13),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'to the destination',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Roboto-Regular'),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  width: 120,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: green_color,
                                    child: Text(
                                      'CALL NOW',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    onPressed: () => _service
                                        .call(apiData['data']['user']['phone']),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 35,
                                  width: 120,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: green_color,
                                    child: Text(
                                      'VIEW MAP',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    onPressed: () async {
                                      // this is our new code for opening maps app

                                      _launchURL(
                                          "google.navigation:q=${apiData['data']['address']['latitude']},${apiData['data']['address']['longitude']}");
                                    },
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0.0, 0, 0),
                          child: DottedBorder(
                            borderType: BorderType.Rect,
                            dashPattern: [5, 5, 5, 5],
                            padding: EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                height: 60,
                                width: 100,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Payment Method',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    Image.asset(
                                      'assets/images/razor-pay.jpg',
                                      height: 20.0,
                                    ),
                                    Text(
                                      '${apiData['data']['amount']}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: EdgeInsets.all(8),
                  child: Material(
                    elevation: 10,
                    child: Table(
                      columnWidths: {
                        1: FractionColumnWidth(.3),
                        2: FractionColumnWidth(.2)
                      },
                      border: TableBorder.all(
                        color: Colors.grey[350],
                      ),
                      children: [
                        TableRow(
                          children: [
                            // Row11(),
                            Container(
                              color: card_black,
                              height: 40,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                padding: EdgeInsets.all(6),
                                child: Text('Item',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),

                            // Row12(),
                            Container(
                              color: card_black,
                              height: 40,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  'Package',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),

                            // Row13(),
                            Container(
                              color: card_black,
                              height: 40,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            // Row21(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                      height: 30,
                                      placeholder: "assets/images/loading.png",
                                      image: apiData['data']['plan']['picture'],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${apiData['data']['plan']['menus'][0]['title']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${apiData['data']['plan']['menus'][0]['description']}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Roboto-Regular'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${apiData['data']['plan']['menus'][1]['title']}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          '${apiData['data']['plan']['menus'][1]['description']}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Roboto-Regular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Row22(),
                            Container(
                              padding: EdgeInsets.all(30),
                              child: Center(
                                child: Text('1 Day'),
                              ),
                            ),

                            // Row23(),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Center(
                                child: Text(
                                    '${apiData['data']['plan']['one_price']}'),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            // Row31(),
                            Container(
                              child: Container(
                                child: Text('Sub Total'),
                                margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                padding: EdgeInsets.all(5),
                              ),
                            ),

                            // Row32(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Text('1 Day'),
                              ),
                            ),

                            // Row33(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                    '${apiData['data']['plan']['one_price']}'),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            // Row41(),
                            Container(
                              child: Container(
                                child: Text('Discount'),
                                margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                padding: EdgeInsets.all(5),
                              ),
                            ),

                            // Row42(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text('---')),
                            ),

                            // Row43(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text('---')),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            // Row51(),
                            Container(
                                child: Container(
                              child: Text('Delivery'),
                              margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                              padding: EdgeInsets.all(5),
                            )),

                            // Row52(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Center(child: Text('---')),
                            ),

                            // Row53(),
                            Container(
                              child: Center(
                                child: Text('0'),
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            // Row61(),
                            Container(
                                child: Container(
                              child: Text('Total'),
                              margin: EdgeInsets.fromLTRB(15, 10, 0, 5),
                              padding: EdgeInsets.all(5),
                            )),

                            // Row62(),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Center(child: Text('')),
                            ),

                            // Row63(),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  'Rs.${apiData['data']['plan']['one_price']}',
                                  style:
                                      TextStyle(color: Colors.deepOrangeAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

// conditional part

                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: Material(
                    elevation: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Delivery Status:',
                            style: TextStyle(
                              fontFamily: 'Roboto-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(80, 5, 0, 20),
                          child: RaisedButton(
                            onPressed: () {
                              updateToActiveStatus(
                                  widget.orderId.toString(), 'Activated');
                            },
                            child: Text(
                              'CONFIRM ORDER PICKUP',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: green_color,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Center(
                                child: Image.asset(
                          'assets/images/confirm_order_pickup.png',
                        ))),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
