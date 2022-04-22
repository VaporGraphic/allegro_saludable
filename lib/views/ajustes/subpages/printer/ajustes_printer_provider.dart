import 'package:allegro_saludable/services/firebase/inventario/inventario_crud_service.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';

class AjustesPrinterProvider extends ChangeNotifier {
  //REFERENCIA PRINTER
  //TextoController
  TextEditingController textoEjemploController = TextEditingController();

  abirDialogImpresora(
      BuildContext context, List<BluetoothInfo> listaImpresoras) {
    final printerService = Provider.of<PrinterService>(context, listen: false);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(15),
            title: Text('Buscar impresora'),
            content: Container(
              width: 600,
              height: 400,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  TextNormal('Selecciona un dispositivo:'),
                  SpaceY(
                    percent: .5,
                  ),
                  for (var printer in listaImpresoras)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7.5),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            printerService.guardarImpresora(context, printer);
                          },
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.bluetooth)],
                          ),
                          title: Text(printer.name),
                          subtitle: Text(printer.macAdress),
                        ),
                      ),
                    )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'))
            ],
          );
        });
  }

  comprobarBluetooth(BuildContext context) async {
    final printerService = Provider.of<PrinterService>(context, listen: false);

    printerService.comprobarBluetooth(context, function: () async {
      final listaPrinter = await printerService.leerImpresoras();
      abirDialogImpresora(context, listaPrinter);
    });
  }

  showAlertEliminar(BuildContext context) {
    final printerService = Provider.of<PrinterService>(context, listen: false);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Eliminar'),
            content: Text('¿Deseas eliminar la impresora seleccionada?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar')),
              ElevatedButton(
                  onPressed: () {
                    printerService.eliminarImpresora(context);
                  },
                  child: Text('Eliminar')),
            ],
          );
        });
  }
}
