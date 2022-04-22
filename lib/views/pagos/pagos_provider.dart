import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PagosProvider extends ChangeNotifier {
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

  crearPago(BuildContext context) {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final cajaCrudService =
        Provider.of<CajaCrudService>(context, listen: false);

    PagoServicioModel pagoServicioProvicional =
        PagoServicioModel(cancelado: false);

    TextEditingController motivoController = TextEditingController();
    TextEditingController costoController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(15),
            title: Text('Crear pago'),
            content: Container(
              width: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextSmall('Motivo del pago'),
                  SpaceY(
                    percent: .5,
                  ),
                  TextField(
                    textInputAction: TextInputAction.next,
                    controller: motivoController,
                    decoration: InputDecoration(
                        hintText: 'Motivo del pago:',
                        prefixIcon:
                            Icon(Icons.drive_file_rename_outline_outlined)),
                  ),
                  SpaceY(),
                  TextSmall('Monto a pagar:'),
                  SpaceY(
                    percent: .5,
                  ),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    keyboardType: TextInputType.number,
                    controller: costoController,
                    decoration: InputDecoration(
                        hintText: 'Cantidad de dinero',
                        prefixIcon: Icon(Icons.payment_outlined)),
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
                    if (motivoController.text.isEmpty ||
                        costoController.text.isEmpty) {
                      okToastService.showOkToast(
                          mensaje: 'Por favor rellena todos los campos');
                    } else {
                      pagoServicioProvicional.fecha = DateTime.now();
                      pagoServicioProvicional.motivo = motivoController.text;
                      pagoServicioProvicional.totalPrecio =
                          double.parse(costoController.text);
                      cajaCrudService.crearPagoCaja(
                          context,
                          PagoServicioModel.fromMap(
                              pagoServicioProvicional.toMap()));
                    }
                  },
                  child: TextNormal(
                    'Crear pago',
                    fontWeight: FontWeight.bold,
                  )),
            ],
          );
        });
  }

  opcionesPago(BuildContext context, String firebaseId) {
    final cajaCrudService =
        Provider.of<CajaCrudService>(context, listen: false);

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SpaceY(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(child: TextLead('Opciones')),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Cancelar pago'),
                              content: Text('¿Deseas cancelar el pago?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cerrar')),
                                ElevatedButton(
                                    onPressed: () {
                                      cajaCrudService.actualizarEstadoPago(
                                          context, firebaseId);
                                    },
                                    child: TextNormal(
                                      'Cancelar pago',
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.do_not_disturb_outlined,
                          color: Colors.red,
                        ),
                        SpaceX(),
                        TextNormal(
                          'Cancelar pago',
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )
                      ],
                    )),
                SpaceY(),
              ],
            ),
          );
        });
  }
}
