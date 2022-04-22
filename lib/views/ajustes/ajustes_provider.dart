import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/spacing/space_widgets.dart';
import 'package:flutter/material.dart';

class AjustesProvider extends ChangeNotifier {
  List<Widget> listTiles(BuildContext context) {
    return [
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AjustesInventarioView()),
          );
        },
        leading: Icon(Icons.inventory_2_outlined),
        title: Text('Administrar inventario'),
      ),
      SpaceY(
        percent: .5,
      ),
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AjustesUsuariosView()),
          );
        },
        leading: Icon(Icons.people_outlined),
        title: Text('Ajustes usuarios'),
      ),
      SpaceY(
        percent: .5,
      ),
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjustesPrinterView()),
          );
        },
        leading: Icon(Icons.print_outlined),
        title: Text('Ajustes impresora'),
      ),
    ];
  }
}
