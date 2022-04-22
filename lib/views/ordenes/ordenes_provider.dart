import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/firebase/caja/caja_crud_service.dart';
import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:allegro_saludable/services/printer/printer_service.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OrdenesProvider extends ChangeNotifier {
  abrirEditor(BuildContext context, OrderModel ordenEditar) async {
    final ordenesEditorProvider =
        Provider.of<OrdenesEditorProvider>(context, listen: false);

    ordenesEditorProvider.establecerOrden(ordenEditar);

    await Future.delayed(Duration(milliseconds: 100));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrdenesEditorView()),
    );
  }

  editarOrden() {}

  showModalOpciones(BuildContext context) {
    final cajaCrudService =
        Provider.of<CajaCrudService>(context, listen: false);

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpaceY(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(child: TextLead('Opciones de caja')),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close))
                    ],
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.black54,
                        ),
                        SpaceX(),
                        TextNormal(
                          'Ver resumen de la caja',
                          color: Colors.black54,
                        )
                      ],
                    )),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(15)),
                    onPressed: () {
                      cajaCrudService.cerrarCaja(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_outlined,
                        ),
                        SpaceX(),
                        TextNormal(
                          'Cerrar caja',
                        )
                      ],
                    )),
                SpaceY(
                  percent: 2,
                ),
              ],
            ),
          );
        });
  }

  abrirCaja(BuildContext context) {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final cajaCrudService =
        Provider.of<CajaCrudService>(context, listen: false);
    TextEditingController dineroController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(15),
            title: Text('Abrir caja'),
            content: Container(
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextNormal(
                    'Dinero incial',
                  ),
                  SpaceY(),
                  TextField(
                    controller: dineroController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.payments_outlined),
                        hintText: 'Dinero inicial en caja'),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar')),
              ElevatedButton(
                  onPressed: () {
                    if (dineroController.text.isNotEmpty) {
                      cajaCrudService.crearCaja(
                          context, double.parse(dineroController.text));
                    } else {
                      okToastService.showOkToast(
                          mensaje: 'Establecer dinero inicial');
                    }
                  },
                  child: Text('Iniciar caja'))
            ],
          );
        });
  }
}
