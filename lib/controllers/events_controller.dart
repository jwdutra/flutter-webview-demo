import 'package:flutter/material.dart';

class EventsController extends ChangeNotifier {
  String events = '';
  String storages = '';
  String cookies = '';
  String messages = 'Switch desligado';

  void setEvents(event) {
    events = "$events $event";
    notifyListeners();
  }

  void setStorage(storage) {
    storages = storage;
    notifyListeners();
  }

  void setCookies(cookie) {
    cookies = cookie;
    notifyListeners();
  }

  void setMessage(message) {
    messages = message;
    notifyListeners();
  }
}
