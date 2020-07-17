import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/ordersdetails/calendarDetail.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Calenderpage extends StatefulWidget {
  Calenderpage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalenderpageState createState() => _CalenderpageState();
}

class _CalenderpageState extends State<Calenderpage>
    with TickerProviderStateMixin {
  List<dynamic> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  Color card_black = Color(0xFF423F3F);
  var apiData, orderId, date, eventDetail;
  bool _isLoading = true;
  Map<DateTime, List<dynamic>> _eventss = {};

  Future<void> getCalendarOrders() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/calendar';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    setState(() {
      apiData = json.decode(response.body);
      _isLoading = false;
    });

    var dates = [];
    apiData.forEach((e) {
      if (!(dates.contains(e['start']))) {
        dates.add(e["start"]);
        _eventss[DateTime.parse(e["start"])] = [
          {'title': e['title'], 'date': e['start'], 'orderId': e['order_id']}
        ];
      } else {
        _eventss[DateTime.parse(e["start"])].add({
          'title': e['title'],
          'date': e['start'],
          'orderId': e['order_id']
        });
      }
    });
    print(_eventss);
  }

  Future<void> getOrderDetail(orderId) async {
    String baseUrll = 'http://hff.nyxwolves.xyz/api/my-order/${orderId}';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var responsee =
        await http.get(baseUrll, headers: {'authorization': basicAuth});
    eventDetail = json.decode(responsee.body);
  }

  @override
  void initState() {
    super.initState();
    getCalendarOrders();
    var _selectedDay = DateTime.now();

    _selectedEvents = _eventss[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
    });
    print(_selectedEvents);
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    // print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calender',
          style: TextStyle(
            fontSize: 23,
            fontFamily: 'Roboto-Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 15,
        backgroundColor: orange_color,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTableCalendar(),
                const SizedBox(height: 8.0),
                const SizedBox(height: 8.0),
                Expanded(child: _buildEventList()),
              ],
            ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Material(
        elevation: 10,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(30),
        child: TableCalendar(
          calendarController: _calendarController,
          events: _eventss,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            todayColor: orange_color,
            selectedColor: green_color,
            markersColor: Colors.blueGrey,
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle(
            formatButtonTextStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
            formatButtonDecoration: BoxDecoration(
              color: Colors.deepOrange[400],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: _onVisibleDaysChanged,
          onCalendarCreated: _onCalendarCreated,
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: green_color),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event['title']),
                  leading: Text(event['date']),
                  dense: false,
                  onTap: () {
                    // to display the order in detail
                    getOrderDetail(event['orderId']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CalendatDetailPage(orderId: event['orderId'])));
                  },
                ),
              ))
          .toList(),
    );
  }
}
