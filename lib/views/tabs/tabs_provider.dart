import 'package:allegro_saludable/views/views.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class TabsProvider extends ChangeNotifier {
  bool noConectionView = false;

  int selectedTab = 0;

  TabsProvider() {
    //checkConectivity(navigatorKey);
  }

  checkConectivity(GlobalKey<NavigatorState> navigatorKey) async {
    var initialStatus = await (Connectivity().checkConnectivity());
    getInternetStatus();

    print(initialStatus);
    if (initialStatus == ConnectivityResult.none) {
      noConectionView = true;
      print('Ninguna red conectada');
      navigatorKey.currentState!.pushNamed('/internet_status');
    } else {
      if (noConectionView == true) {
        Navigator.pop(navigatorKey.currentContext!);
      }
      noConectionView = false;
    }

    var conectionStatus = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      getInternetStatus();

      print('ESTADO LISTEN $connectivityResult');

      if (connectivityResult == ConnectivityResult.none) {
        noConectionView = true;
        print('Ninguna red conectada');
        navigatorKey.currentState!.pushNamed('/internet_status');
      } else {
        if (noConectionView == true) {
          Navigator.pop(navigatorKey.currentContext!);
        }
        noConectionView = false;
      }
    });
  }

  cambiarTab(int selectedTab) {
    this.selectedTab = selectedTab;
    notifyListeners();
  }

  Future<bool> getInternetStatus() async {
    if (kIsWeb) {
      print('IS WEB');
      return true;
    } else {
      bool internetStatus = await InternetConnectionChecker().hasConnection;
      print(
          'STATUS $internetStatus, status${await InternetConnectionChecker().connectionStatus}');

      return internetStatus;
    }
  }

  Widget obtenerView() {
    switch (selectedTab) {
      case 0:
        return HomeView();
      case 1:
        return MenuView();
      case 2:
        return OrdenesView();
      case 3:
        return AjustesView();
    }

    return HomeView();
  }
}
