import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/ajustes/subpages/printer/ajustes_printer_provider.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AjustesPrinterView extends StatelessWidget {
  const AjustesPrinterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ajustesPrinterProvider = Provider.of<AjustesPrinterProvider>(context);
    final printerService = Provider.of<PrinterService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ajustesPrinterProvider.comprobarBluetooth(context);
        },
        child: Icon(Icons.search),
      ),
      appBar: AppBarWidget(
        title: 'Ajustes impresora',
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextTitle('Ajustes impresora'),
          TextNormal('Administra tu impresora globalmente'),
          SpaceY(),
          TextNormal(
            'Impresora seleccionada:',
            color: Colors.grey,
          ),
          SpaceY(),
          printerService.impresoraEstablecida == null
              ? Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print_outlined),
                      ],
                    ),
                    title: Text('Ninguna impresora'),
                    subtitle: Text('Selecciona una con la lupa'),
                  ),
                )
              : Material(
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      ajustesPrinterProvider.showAlertEliminar(context);
                    },
                    tileColor: Colors.deepPurpleAccent,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print_outlined, color: Colors.white),
                      ],
                    ),
                    title: TextNormal(
                      printerService.impresoraEstablecida!.name,
                      color: Colors.white,
                    ),
                    subtitle: TextNormal(
                        printerService.impresoraEstablecida!.macAdress,
                        color: Colors.white),
                  ),
                ),
          SpaceY(),
          TextNormal(
            'Texto de prueba:',
            color: Colors.grey,
          ),
          SpaceY(),
          TextField(
            controller: ajustesPrinterProvider.textoEjemploController,
            maxLines: 2,
            decoration: InputDecoration(hintText: 'Texto de ejemplo'),
          ),
          SpaceY(),
          ElevatedButton(
              onPressed: printerService.impresoraEstablecida != null &&
                      printerService.switchConectandoPrinter == false
                  ? () {
                      printerService.imprimir(context,
                          textTest: ajustesPrinterProvider
                              .textoEjemploController.text,
                          cerrar: false,
                          opcion: 0);
                    }
                  : null,
              child: printerService.switchConectandoPrinter == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_outlined),
                        SpaceX(
                          percent: .5,
                        ),
                        Text('Imprimir texto de ejemplo'),
                      ],
                    )
                  : CircularProgressIndicator())
        ],
      ),
    );
  }
}
