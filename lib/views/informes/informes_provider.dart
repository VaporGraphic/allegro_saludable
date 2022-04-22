import 'package:allegro_saludable/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformesProvider extends ChangeNotifier {
  actualizar(BuildContext context) {
    final informesCrudService =
        Provider.of<InformesCrudService>(context, listen: false);

    informesCrudService.obtenerInformes();
  }

  comprobarMaximo(BuildContext context, {required int indexTileRendereada}) {
    final informesCrudService =
        Provider.of<InformesCrudService>(context, listen: false);

    if (informesCrudService.paginaActual +
            informesCrudService.cantidadMaximaDocumentos ==
        indexTileRendereada) {
      print('Se alcanzó a la cantidad maxima, cargando más');

      informesCrudService.cargarMasInformes();
    }
  }

  cargarMas(BuildContext context) {
    final informesCrudService =
        Provider.of<InformesCrudService>(context, listen: false);

    informesCrudService.cargarMasInformes();
  }
}
