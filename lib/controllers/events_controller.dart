import 'package:flutter/material.dart';

class EventsController extends ChangeNotifier {
  String events = '';

  void setEvents(event) {
    events = "$events enent";
    notifyListeners();
  }
}
