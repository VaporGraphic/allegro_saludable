import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/ordenes/widgets/tile_orden.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdenesView extends StatelessWidget {
  const OrdenesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordenesProvider = Provider.of<OrdenesProvider>(context);
    final cajaCrudService = Provider.of<CajaCrudService>(context);

    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          IconButton(
              onPressed: () {
                ordenesProvider.showModalOpciones(context);
              },
              icon: Icon(Icons.more_vert_outlined))
        ],
      ),
      body: cajaCrudService.cajaActual != null
          ? cajaAbierta(ordenesProvider, context)
          : cajaCerrada(context, cajaCrudService, ordenesProvider),
    );
  }

  Widget cajaCerrada(BuildContext context, CajaCrudService cajaCrudService,
      OrdenesProvider ordenesProvider) {
    return cajaCrudService.cargandoCajas == false
        ? Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextNormal('Caja cerrada actualmente',
                    textAlign: TextAlign.center),
                SpaceY(),
                ElevatedButton(
                    onPressed: () {
                      ordenesProvider.abrirCaja(context);
                    },
                    child: Text('  Abrir caja  '))
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  ListView cajaAbierta(OrdenesProvider ordenesProvider, BuildContext context) {
    final cajaCrudService = Provider.of<CajaCrudService>(context);

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(15),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitle('Ordenes actuales'),
                Text('Historial de ordenes'),
              ],
            )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.deepPurpleAccent,
                ))
          ],
        ),
        SpaceY(),
        Row(
          children: [
            TextSmall(
              'Todas las ordenes',
              color: Colors.grey,
            )
          ],
        ),
        SpaceY(),
        if (cajaCrudService.cajaActual != null)
          for (var orden in cajaCrudService.cajaActual!.listOrdenes!)
            TileOrden(
              onTap: () {
                ordenesProvider.abrirEditor(
                    context, OrderModel.fromMap(orden.toMap()));
              },
              fecha: orden.fecha!,
              total: orden.totalPrecio!,
              envio: orden.switchEnvio!,
              hora:
                  '${orden.fecha!.hour.toString().padLeft(2, '0')}:${orden.fecha!.minute.toString().padLeft(2, '0')}',
              estado: orden.estadoPedido!,
              nombre: orden.cliente!,
            )
      ],
    );
  }
}
