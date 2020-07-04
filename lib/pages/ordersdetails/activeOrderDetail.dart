import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// call now ability stuff starts here
class CallsAndMessagesService {
  updateStatus() async {}
  void call(String number) => launch("tel:$number");
}

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}

final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
// call now ability stuff ends here

class ActiveOrderDetail extends StatefulWidget {
  var orderNo,
      date,
      time,
      name,
      phone,
      address,
      amount,
      onePrice,
      foodPicture,
      menuTitle01,
      menuDescription01,
      menuTitle02,
      menuDescription02,
      deliveryStatus,
      longitude,
      latitude,
      distance,
      assignee_id;

// using the constructor to get the data from the 'active_order.dart' file
  ActiveOrderDetail(
      {this.orderNo,
      this.date,
      this.time,
      this.name,
      this.phone,
      this.address,
      this.amount,
      this.onePrice,
      this.foodPicture,
      this.menuTitle01,
      this.menuDescription01,
      this.menuTitle02,
      this.menuDescription02,
      this.deliveryStatus,
      this.longitude,
      this.latitude,
      this.distance,
      this.assignee_id});

  @override
  _ActiveOrderDetailState createState() => _ActiveOrderDetailState();
}

class _ActiveOrderDetailState extends State<ActiveOrderDetail> {
  Color title_bar_color = Color(0xFFE5E5E5);
  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  Color card_black = Color(0xFF423F3F);
  Color dark_white = Colors.white;
  Color light_white = Color(0xFFd4d2d2);
  Map _statusResponse;

  Future updateToDeliveredStatus(String assignee_id, String status) async {
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
  Widget build(BuildContext context) {
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
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Text('Order No: ${widget.orderNo}',
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
                        Text(widget.date,
                            style: TextStyle(
                                fontSize: 13, fontFamily: 'Roboto-Regular')),
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
                          widget.time,
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
                                widget.name,
                                style: TextStyle(color: orange_color),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.phone,
                            style: TextStyle(
                                fontSize: 13, fontFamily: 'Roboto-Regular'),
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
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 190,
                            child: Text(widget.address,
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
                                fontWeight: FontWeight.bold, fontSize: 16),
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
                                  '${widget.distance} km',
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
                              onPressed: () => _service.call(widget.phone),
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
                                    "google.navigation:q=${widget.latitude},${widget.longitude}");
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
                        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                widget.amount,
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                                image: widget.foodPicture,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.menuTitle01,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    widget.menuDescription01,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Roboto-Regular'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.menuTitle02,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    widget.menuDescription02,
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
                          child: Text(widget.onePrice),
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
                          child: Text(widget.onePrice),
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
                            'Rs.${widget.onePrice}',
                            style: TextStyle(color: Colors.deepOrangeAccent),
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
          widget.deliveryStatus != 'Delivered'
              ? Container(
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
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFFFFBC00),
                              ),
                              Text('Order Picked Up')
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(80, 5, 0, 20),
                          child: RaisedButton(
                            onPressed: () {
                              updateToDeliveredStatus(
                                  widget.assignee_id.toString(), 'Delivered');
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
                          'assets/images/confirm_order_delivery.png',
                        ))),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              : Container(
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
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                color: green_color,
                              ),
                              Text(
                                'Delivery Completed',
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Center(
                                child: Image.asset(
                          'assets/images/delevery-completed.png',
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
