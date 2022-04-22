import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/caja/caja_crud_service.dart';
import 'package:allegro_saludable/services/printer/printer_service.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdenesEditorProvider extends ChangeNotifier {
  OrderModel? ordenEditar;

  establecerOrden(OrderModel ordenObtenida) {
    ordenEditar = ordenObtenida;
    notifyListeners();
  }

  mostrarOpciones(BuildContext context) {
    final printerService = Provider.of<PrinterService>(context, listen: false);

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextLead('Opciones de orden'),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close_outlined),
                      )
                    ],
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
                    onPressed: () {
                      Navigator.pop(context);
                      opcionesImprimir(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.print_outlined, color: Colors.black54),
                        SpaceX(),
                        TextNormal(
                          'Volver a imprimir ticket',
                          color: Colors.black54,
                        )
                      ],
                    )),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
                    onPressed: () {
                      Navigator.pop(context);
                      cancelarOrden(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.block_outlined, color: Colors.red),
                        SpaceX(),
                        TextNormal(
                          'Cancelar orden',
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )
                      ],
                    )),
                SpaceY()
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
          );
        });
  }

  opcionesImprimir(BuildContext context) {
    final printerService = Provider.of<PrinterService>(context, listen: false);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(15),
            title: Row(
              children: [
                Icon(Icons.print_outlined),
                SpaceX(),
                Text('Imprimir ticket'),
              ],
            ),
            content: Container(
              width: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        printerService.imprimir(context,
                            orderModel: ordenEditar, opcion: 1, cerrar: false);
                      },
                      child: Text('Imprimir ticket')),
                  SpaceY(),
                  ElevatedButton(
                      onPressed: () {
                        printerService.imprimir(context,
                            orderModel: ordenEditar, opcion: 2, cerrar: false);
                      },
                      child: Text('Imprimir comanda')),
                  SpaceY(),
                  ElevatedButton(
                      onPressed: () {
                        printerService.imprimir(context,
                            orderModel: ordenEditar, opcion: 0, cerrar: false);
                      },
                      child: Text('Imprimir ambos')),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar')),
            ],
          );
        });
  }

  cancelarOrden(BuildContext context) {
    final cajaCrudService =
        Provider.of<CajaCrudService>(context, listen: false);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cancelar orden'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Deseas cancelar la orden?'),
                TextSmall('La accion no es reversible')
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar')),
              ElevatedButton(
                  onPressed: () {
                    cajaCrudService.cancelarOrden(
                        context: context,
                        orderFirebaseId: ordenEditar!.firebaseId!,
                        cajaActual: true);
                  },
                  child: Text('Cancelar orden'))
            ],
          );
        });
  }
}
