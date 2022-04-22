import 'package:flutter/material.dart';

class InternetStatusView extends StatelessWidget {
  const InternetStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
        ),
        body: Center(
          child: Text('No hay conexion a internet:('),
        ),
      ),
    );
  }
}
