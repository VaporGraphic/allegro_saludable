import 'package:allegro_saludable/services/firebase/caja/caja_crud_service.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PagosView extends StatelessWidget {
  const PagosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cajaCrudService = Provider.of<CajaCrudService>(context);
    final pagosProvider = Provider.of<PagosProvider>(context);

    return cajaCrudService.cajaActual != null
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                pagosProvider.crearPago(context);
              },
              child: Icon(Icons.add),
            ),
            appBar: AppBarWidget(
              actions: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
              ],
            ),
            body: ListView(
              padding: EdgeInsets.all(15),
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitle('Historial de pagos'),
                        Text('Pago de servicio realizados')
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
                for (var pago in cajaCrudService.cajaActual!.listPagos!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.5),
                    child: ListTile(
                      onTap: () {
                        pagosProvider.opcionesPago(context, pago.firebaseId!);
                      },
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          pago.cancelado == false
                              ? Ink(
                                  width: 10,
                                )
                              : Ink(
                                  child: TextSmall(
                                    'Cancelado',
                                    color: Colors.grey,
                                  ),
                                ),
                          TextNormal(
                            '\$${pago.totalPrecio}',
                            fontWeight: FontWeight.bold,
                            color: pago.cancelado == false
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ],
                      ),
                      title: TextNormal('${pago.motivo}'),
                      subtitle: Text(
                          '${pago.fecha!.hour.toString().padLeft(2, '0')}:${pago.fecha!.minute.toString().padLeft(2, '0')}'),
                    ),
                  )
              ],
            ),
          )
        : Scaffold(
            appBar: AppBarWidget(),
            body: Center(
              child: cajaCrudService.cargandoCajas == false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Caja cerrada actualmente'),
                        SpaceY(),
                        ElevatedButton(
                            onPressed: () {
                              pagosProvider.abrirCaja(context);
                            },
                            child: Text('Abrir caja'))
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
          );
  }
}
