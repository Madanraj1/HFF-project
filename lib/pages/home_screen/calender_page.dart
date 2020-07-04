import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  Color green_color = Color(0xFF9AC632);
  Color orange_color = Color(0xFFF95E21);
  Color card_black = Color(0xFF423F3F);
  var apiData;
  bool _isLoading = true;
  Map<DateTime, List> _eventss = {};

  Future<String> getCalendarOrders() async {
    String baseUrl = 'http://hff.nyxwolves.xyz/api/calendar';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String basicAuth = sharedPreferences.getString("token");
    var response =
        await http.get(baseUrl, headers: {'authorization': basicAuth});
    setState(() {
      apiData = json.decode(response.body);
      _isLoading = false;
    });
    for (var i = 0; i < apiData.length; i++) {
      _eventss[DateTime.parse(apiData[i]['start'])] = [apiData[i]['title']];
    }
    print(_eventss);
  }

  @override
  void initState() {
    super.initState();
    getCalendarOrders();
    final _selectedDay = DateTime.now();

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
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
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
                // Switch out 2 lines below to play with TableCalendar's settings
                //-----------------------
                _buildTableCalendar(),
                // _buildTableCalendarWithBuilders(),
                const SizedBox(height: 8.0),
                // _buildButtons(),
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
          // events: _events,
          events: _eventss,
          // holidays: _holidays,
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

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                // change this color to green
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
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
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
