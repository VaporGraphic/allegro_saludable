import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';

class InformesInfoView extends StatelessWidget {
  const InformesInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Detalles caja',
      ),
      body: ListView(
        children: [TextTitle('Resumen caja'), Text('')],
      ),
    );
  }
}
