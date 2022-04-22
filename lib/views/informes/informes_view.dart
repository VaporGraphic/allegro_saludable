import 'package:allegro_saludable/models/caja/caja_model.dart';
import 'package:allegro_saludable/services/firebase/informes/informes_crud_service.dart';
import 'package:allegro_saludable/views/informes/informes_provider.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformesView extends StatelessWidget {
  const InformesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final informesCrudService = Provider.of<InformesCrudService>(context);
    final informesProvider = Provider.of<InformesProvider>(context);

    String obtenerMes(int mes) {
      switch (mes) {
        case 1:
          return 'Enero';
        case 2:
          return 'Febrero';
        case 3:
          return 'Marzo';
        case 4:
          return 'Abril';
        case 5:
          return 'Mayo';
        case 6:
          return 'Junio';
        case 7:
          return 'Julio';
        case 8:
          return 'Agosto';
        case 9:
          return 'Septiembre';
        case 10:
          return 'Octubre';
        case 11:
          return 'Noviembre';
        case 12:
          return 'Diciembre';
        default:
          return 'mes indefinido';
      }
    }

    List<Widget> CajasTiles() {
      List<Widget> widgetsFechas = [];

      String ultimoDia = '';

      for (var i = 0; i < informesCrudService.listCajas.length; i++) {
        if (ultimoDia.isEmpty) {
          ultimoDia =
              '${informesCrudService.listCajas[i].fecha!.day} de ${obtenerMes(informesCrudService.listCajas[i].fecha!.month)} del ${informesCrudService.listCajas[i].fecha!.year}';

          widgetsFechas.add(Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextTitle(ultimoDia),
          ));
        } else {
          if ('${informesCrudService.listCajas[i].fecha!.day} de ${obtenerMes(informesCrudService.listCajas[i].fecha!.month)} del ${informesCrudService.listCajas[i].fecha!.year}' !=
              ultimoDia) {
            ultimoDia =
                '${informesCrudService.listCajas[i].fecha!.day} de ${obtenerMes(informesCrudService.listCajas[i].fecha!.month)} del ${informesCrudService.listCajas[i].fecha!.year}';
            widgetsFechas.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextTitle(ultimoDia),
            ));
          }
        }

        widgetsFechas.add(OrdenTile(
          caja: informesCrudService.listCajas[i],
          indexActual: i,
        ));
      }

      return widgetsFechas;
    }

    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
              onPressed: () {
                informesProvider.actualizar(context);
              },
              child: TextNormal(
                'Actualizar',
                fontWeight: FontWeight.bold,
              ))
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle('Informes de venta'),
                    Text('Revisa tus informes de venta'),
                  ],
                ),
              ),
            ],
          ),
          SpaceY(),
          ...CajasTiles(),
          informesCrudService.cargandoInformes == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class OrdenTile extends StatelessWidget {
  final int indexActual;

  const OrdenTile({
    Key? key,
    required this.caja,
    required this.indexActual,
  }) : super(key: key);

  final CajaModel caja;

  @override
  Widget build(BuildContext context) {
    final informesProvider = Provider.of<InformesProvider>(context);

    informesProvider.comprobarMaximo(context,
        indexTileRendereada: indexActual + 1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 7.5),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          trailing: TextNormal(
            '${caja.total}',
            fontWeight: FontWeight.bold,
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.receipt_outlined)],
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextSmall(
                    '${caja.fecha!.hour.toString().padLeft(2, '0')}:${caja.fecha!.minute.toString().padLeft(2, '0')}'),
                TextNormal('Ordenes ${caja.listOrdenes!.length}')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
