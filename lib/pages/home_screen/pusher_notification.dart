import 'package:flutter/material.dart';
import 'package:homely_fresh_food/services/pusher_service.dart';

class PusherNotification extends StatefulWidget {
  @override
  _PusherNotificationState createState() => _PusherNotificationState();
}

class _PusherNotificationState extends State<PusherNotification> {
  PusherService pusherService = PusherService();
  @override
  void initState() {
    pusherService = PusherService();
    pusherService.firePusher('public', 'create');
    super.initState();
  }

  @override
  void dispose() {
    pusherService.unbindEvent('create');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: StreamBuilder(
          stream: pusherService.eventStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Container(
              child: Text(snapshot.data),
            );
          },
        ),
      ),
    );
  }
}
