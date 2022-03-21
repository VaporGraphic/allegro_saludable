import 'dart:async';

import 'package:flutter/material.dart';

class ClockService extends ChangeNotifier {
  String dateTimeString = '';

  ClockService() {
    obtenerHoraActual();
  }

  obtenerHoraActual() async {
    Timer.periodic(Duration(seconds: 1), (time) {
      DateTime dateTime = DateTime.now();
      dateTimeString =
          ' ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      notifyListeners();
    });
  }
}
