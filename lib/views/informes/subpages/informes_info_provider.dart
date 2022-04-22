import 'package:allegro_saludable/models/caja/caja_model.dart';
import 'package:flutter/material.dart';

class InformesInfoProvider extends ChangeNotifier {
  CajaModel? cajaEditable = null;

  establecerCaja(CajaModel caja) {
    cajaEditable = caja;
    notifyListeners();
  }
}
