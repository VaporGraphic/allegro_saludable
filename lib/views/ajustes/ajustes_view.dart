import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesView extends StatelessWidget {
  const AjustesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ajustesProvider = Provider.of<AjustesProvider>(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Ajustes',
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        children: [
          TextTitle('Ajustes'),
          TextNormal('Administra tu negocio'),
          SpaceY(),
          ...ajustesProvider.listTiles(context)
        ],
      ),
    );
  }
}
