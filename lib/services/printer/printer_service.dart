import 'dart:typed_data';

import 'package:allegro_saludable/models/models.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';

import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as ImagePrinter;

class PrinterService extends ChangeNotifier {
  //ESTABLECIENDO CONEXION
  bool switchConectandoPrinter = false;

  GlobalKey<NavigatorState>? navigatorKey = null;
  //REFERENCIA PRINTER
  CollectionReference inventarioFirebaseReference =
      FirebaseFirestore.instance.collection('impresoras');

  //BLUETOOTH PRINTER
  BluetoothInfo? impresoraEstablecida = null;

  PrinterService(GlobalKey<NavigatorState> getNavigatorKey) {
    navigatorKey = getNavigatorKey;
    obtenerImpresora();
  }

  obtenerImpresora() async {
    return inventarioFirebaseReference
        .doc('printer')
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        Map impresoraObtenida = event.data() as Map<String, dynamic>;

        impresoraEstablecida = BluetoothInfo(
            name: impresoraObtenida['name'],
            macAdress: impresoraObtenida['macAdress']);
        print('Actualizacion de impresora exitosa, ${impresoraObtenida}');
      } else {
        impresoraEstablecida = null;
      }
      notifyListeners();
    });
  }

  guardarImpresora(BuildContext context, BluetoothInfo impresora) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    await inventarioFirebaseReference
        .doc('printer')
        .set({'name': impresora.name, 'macAdress': impresora.macAdress}).then(
            (value) {
      Navigator.pop(context);
      okToastService.showOkToast(
          mensaje: 'Impresora establecida correctamente');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al establecer, invente nuevamente');
    });
  }

  eliminarImpresora(BuildContext context) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);

    await inventarioFirebaseReference.doc('printer').delete().then((value) {
      Navigator.pop(context);
      okToastService.showOkToast(mensaje: 'Impresora eliminada correctamente');
    }).catchError((error) {
      okToastService.showOkToast(
          mensaje: 'Error al eliminar, invente nuevamente ');
      print('Error: ${error.toString()}');
    });
    notifyListeners();
  }

  comprobarBluetooth(BuildContext context, {required Function function}) async {
    bool estaActivado = await PrintBluetoothThermal.bluetoothEnabled;

    if (estaActivado == true) {
      function();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Bluetooth desactivado'),
              content: Text(
                  'Enciende el Bluetooth para las funciones de la impresora'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cerrar')),
                ElevatedButton(
                    onPressed: () {
                      OpenSettings.openBluetoothSetting();
                      Navigator.pop(context);
                    },
                    child: Text('Abrir ajustes'))
              ],
            );
          });
    }
  }

  Future<List<BluetoothInfo>> leerImpresoras() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });

    return listResult;
  }

  imprimir(
    BuildContext context, {
    String? textTest,
    OrderModel? orderModel,
    required int opcion,
    required bool cerrar,
  }) async {
    final okToastService = Provider.of<OkToastService>(context, listen: false);
    final paymentSuccessProvider =
        Provider.of<PaymentSuccessProvider>(context, listen: false);

    await PrintBluetoothThermal.disconnect;

    comprobarBluetooth(context, function: () async {
      if (impresoraEstablecida != null) {
        switchConectandoPrinter = true;
        notifyListeners();
        final bool result = await PrintBluetoothThermal.connect(
            macPrinterAddress: impresoraEstablecida!.macAdress);

        if (result == true) {
          if (textTest != null) {
            //IMPRIMIR TEST
            List<int> ticket = await testTicket(textTest);
            print(ticket);
            final result1 = await PrintBluetoothThermal.writeBytes(ticket);
            print("print result: $result1");
          } else {
            //IMPRIMIR Tickets

            List<int> ticket = await orderTicket(orderModel!);
            List<int> comanda = await comandaTicket(orderModel);

            //OPCION 0 == TODOS
            if (opcion == 0) {
              final result1 = await PrintBluetoothThermal.writeBytes(ticket);
              await Future.delayed(const Duration(seconds: 7), () {});
              final result2 = await PrintBluetoothThermal.writeBytes(comanda);
            }

            //OPCION 1 == TICKET
            if (opcion == 1) {
              final result1 = await PrintBluetoothThermal.writeBytes(ticket);
            }

            //OPCION 2 == COMANDA
            if (opcion == 2) {
              final result1 = await PrintBluetoothThermal.writeBytes(comanda);
            }
          }

          await PrintBluetoothThermal.disconnect;
          switchConectandoPrinter = false;
          notifyListeners();
          okToastService.showOkToast(mensaje: 'Ticket impreso exitosamente');
          if (cerrar == true) {
            //CERRAR ORDEN
            paymentSuccessProvider.cerrarExito(context);
          }
        } else {
          switchConectandoPrinter = false;
          notifyListeners();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('No se ha podido establecer conexion'),
                  content: Text(
                      'Revisa que tu impresora esté encendida y cerca de tí'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Aceptar'))
                  ],
                );
              });
        }
      } else {
        switchConectandoPrinter = false;
        notifyListeners();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Ninguna impresora seleccionada'),
                content: Text('Por favor ve a ajustes/impresoras'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Aceptar'))
                ],
              );
            });
      }
    });
  }

  Future<List<int>> testTicket(String texto) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.feed(2);

    final ByteData dataImage =
        await rootBundle.load('assets/brand/logo_print.png');
    final Uint8List bytesImage = dataImage.buffer.asUint8List();
    final ImagePrinter.Image image = ImagePrinter.decodeImage(bytesImage)!;

    bytes += generator.imageRaster(image,
        align: PosAlign.center,
        highDensityHorizontal: true,
        highDensityVertical: true);

    bytes += generator.feed(2);

    bytes += generator.text(
        texto.isNotEmpty ? '$texto' : 'Ningun texto escrito',
        styles: PosStyles(
            bold: true, fontType: PosFontType.fontA, align: PosAlign.center));

    bytes += generator.feed(1);

    bytes += generator.text('Envianos mensaje por whatsapp',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));

    bytes += generator.text('+52 1 554 265 9805',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));

    bytes += generator.feed(1);

    bytes += generator.qrcode('https://wa.me/5215542659805');
    bytes += generator.feed(2);
    bytes += generator.text('-----------------------------------------',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));
    return bytes;
  }

  Future<List<int>> orderTicket(OrderModel modelo) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    // Using `ESC *`
    final ByteData dataImage =
        await rootBundle.load('assets/brand/logo_print.png');
    final Uint8List bytesImage = dataImage.buffer.asUint8List();
    final ImagePrinter.Image image = ImagePrinter.decodeImage(bytesImage)!;

    bytes += generator.imageRaster(image,
        align: PosAlign.center,
        highDensityHorizontal: true,
        highDensityVertical: true);

    bytes += generator.feed(1);

    bytes += generator.text('Cliente:',
        styles: PosStyles(
          fontType: PosFontType.fontB,
        ));

    bytes += generator.text('${modelo.cliente}',
        styles: PosStyles(
          bold: true,
          fontType: PosFontType.fontA,
        ));

    if (modelo.switchEnvio == false) {
      bytes += generator.row([
        PosColumn(
          text: 'Mesa:',
          width: 3,
          styles: PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '${modelo.ubicacionLocal}',
          width: 9,
          styles: PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.right,
          ),
        ),
      ]);
    } else {
      bytes += generator.row([
        PosColumn(
          text: 'Ubicacion:',
          width: 3,
          styles: PosStyles(
            underline: true,
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '${modelo.ubicacion}',
          width: 9,
          styles: PosStyles(
            fontType: PosFontType.fontA,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Telefono:',
          width: 3,
          styles: PosStyles(
            underline: true,
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '${modelo.numero}',
          width: 9,
          styles: PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Costo envio:',
          width: 3,
          styles: PosStyles(
            underline: true,
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '\$${modelo.envioPrecio}',
          width: 9,
          styles: PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (modelo.switchTarjeta == false) {
      bytes += generator.row([
        PosColumn(
          text: 'Efectivo:',
          width: 3,
          styles: PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '\$${modelo.efectivoRecibido}',
          width: 9,
          styles: PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Cambio:',
          width: 3,
          styles: PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '\$${modelo.cambioEntregado}',
          width: 9,
          styles: PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.right,
          ),
        ),
      ]);
    } else {
      bytes += generator.row([
        PosColumn(
          text: 'Referencia tarjeta:',
          width: 3,
          styles: PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: '\$${modelo.referenciaTarjeta}',
          width: 9,
          styles: PosStyles(
            fontType: PosFontType.fontA,
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    bytes += generator.row([
      PosColumn(
        text: 'Subtotal:',
        width: 3,
        styles: PosStyles(
          fontType: PosFontType.fontB,
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: '\$${modelo.subtotalPrecio}',
        width: 9,
        styles: PosStyles(
          fontType: PosFontType.fontA,
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += generator.feed(1);

    bytes += generator.row([
      PosColumn(
        text: 'Total:',
        width: 3,
        styles: PosStyles(
          fontType: PosFontType.fontA,
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: '\$${modelo.subtotalPrecio}',
        width: 9,
        styles: PosStyles(
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          underline: true,
          bold: true,
          fontType: PosFontType.fontA,
          align: PosAlign.center,
        ),
      ),
    ]);

    bytes += generator.feed(1);
    bytes += generator.text(
        '--- Productos vendidos ${modelo.itemsList!.length} ---',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));
    bytes += generator.feed(1);

    //IMPRIMIR PRODUCTOS

    for (var producto in modelo.itemsList!) {
      bytes += generator.row([
        PosColumn(
          text: 'Cantidad: ${producto.cantidad}',
          width: 6,
          styles: PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          containsChinese: false,
          text: 'Costo \$${producto.totalPrecio} ',
          width: 6,
          styles: PosStyles(
            bold: true,
            fontType: PosFontType.fontA,
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += generator.text(
          '-${producto.nombre} ${producto.modeloSeleccionado!.subnombre} - \$${producto.modeloSeleccionado!.precio}',
          styles: PosStyles(fontType: PosFontType.fontA, align: PosAlign.left));

      //COMPLEMENTOS
      for (var complemento in producto.listComplementos!) {
        if (complemento.seleccionado == true) {
          bytes += generator.text(' -${complemento.complementoData.nombre}',
              styles:
                  PosStyles(fontType: PosFontType.fontB, align: PosAlign.left));
        }
      }
      //EXTRAS

      for (var extra in producto.listExtras!) {
        if (extra.cantidad > 0) {
          bytes += generator.text(
              ' -(x${extra.cantidad}) ${extra.extraData.nombre} - ${extra.subtotal}',
              styles: PosStyles(
                fontType: PosFontType.fontB,
                align: PosAlign.left,
              ),
              containsChinese: true);
        }
      }
      bytes += generator.feed(1);
    }

    bytes += generator.feed(1);

    bytes += generator.text('Envianos mensaje por whatsapp',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));

    bytes += generator.text('+52 1 554 265 9805',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));

    bytes += generator.feed(1);

    bytes += generator.qrcode('https://wa.me/5215542659805');
    bytes += generator.feed(2);
    bytes += generator.text('-----------------------------------------',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));
    bytes += generator.feed(1);

    return bytes;
  }

  Future<List<int>> comandaTicket(OrderModel modelo) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    // Using `ESC *`
    bytes += generator.text('Comanda',
        styles: PosStyles(
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          underline: true,
          bold: true,
          fontType: PosFontType.fontA,
          align: PosAlign.center,
        ));

    //bytes += generator.feed(1);

    bytes += generator.text('Cliente:',
        styles: PosStyles(
          fontType: PosFontType.fontB,
        ));

    bytes += generator.text('${modelo.cliente}',
        styles: PosStyles(
          bold: true,
          fontType: PosFontType.fontA,
        ));

    List<CategoriaModel> listCategorias = [];

    for (var item in modelo.itemsList!) {
      if (listCategorias.isEmpty) {
        listCategorias.add(item.categoria!);
      } else {
        bool seleccionado = false;

        for (var categoria in listCategorias) {
          if (categoria.firebaseId == item.categoria!.firebaseId &&
              categoria.nombre == item.categoria!.nombre) {
            seleccionado = true;
            break;
          }
        }

        if (seleccionado == false) {
          listCategorias.add(item.categoria!);
        }
      }
    }

    bytes += generator.text('CANTIDAD CATEGORIAS ${listCategorias.length}');

    bytes += generator.feed(1);
    bytes += generator.text('.........................................',
        styles: PosStyles(align: PosAlign.center, fontType: PosFontType.fontB));
    bytes += generator.feed(1);

    for (var categoria in listCategorias) {
      //NOMBRE DE CATEGORIA
      bytes += generator.text('${categoria.nombre.toUpperCase()}',
          styles: PosStyles(
            underline: true,
            bold: true,
            fontType: PosFontType.fontA,
            align: PosAlign.center,
          ));
      //DATOS
      bytes += generator.text(
          '${modelo.fecha!.day}/${modelo.fecha!.month}/${modelo.fecha!.year}  ${modelo.fecha!.hour.toString().padLeft(2, '0')}:${modelo.fecha!.minute.toString().padLeft(2, '0')}',
          styles: PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.center,
          ));
      //NOMBRE CLIENTE
      bytes += generator.text('Cliente: ${modelo.cliente}',
          styles: PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.center,
          ));

      for (var item in modelo.itemsList!) {
        if (categoria.nombre == item.categoria!.nombre &&
            categoria.firebaseId == item.categoria!.firebaseId) {
          //CANTIDAD Y DETALLES
          bytes += generator.feed(1);
          bytes += generator.row([
            PosColumn(
              text: 'Cantidad: ${item.cantidad}',
              width: 6,
              styles: PosStyles(
                fontType: PosFontType.fontB,
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              containsChinese: false,
              text: '',
              width: 6,
              styles: PosStyles(
                bold: true,
                fontType: PosFontType.fontA,
                align: PosAlign.right,
              ),
            ),
          ]);

          bytes += generator.text(
              '-${item.nombre} ${item.modeloSeleccionado!.subnombre}',
              styles: PosStyles(
                bold: true,
                fontType: PosFontType.fontA,
                align: PosAlign.left,
              ));

          for (var complemento in item.listComplementos!) {
            if (complemento.seleccionado == true &&
                complemento.complementoData.imprimirSeparado == false) {
              if (item.notaExtra!.isNotEmpty) {
                bytes +=
                    generator.text('  -${complemento.complementoData.nombre}',
                        styles: PosStyles(
                          fontType: PosFontType.fontB,
                          align: PosAlign.left,
                        ));
              }
            } else if (complemento.seleccionado == true &&
                complemento.complementoData.imprimirSeparado == true) {
              print('Elemento seleccionado de otra categoria');
            }
          }

          for (var extra in item.listExtras!) {
            if (extra.cantidad > 0 &&
                extra.extraData.imprimirSeparado == false) {
              bytes += generator.text(
                  '  -${extra.cantidad} ${extra.extraData.nombre}',
                  styles: PosStyles(
                    fontType: PosFontType.fontB,
                    align: PosAlign.left,
                  ));
            }
          }

          if (item.notaExtra!.isNotEmpty) {
            bytes += generator.text(' Nota: ${item.notaExtra}',
                styles: PosStyles(
                  underline: true,
                  fontType: PosFontType.fontB,
                  align: PosAlign.left,
                ));
          }
        }

        //COMPLEMENTO TAMAÑO COMPLETO
        for (var complemento in item.listComplementos!) {
          if (complemento.seleccionado == true &&
              complemento.complementoData.imprimirSeparado == true) {
            bytes += generator.feed(1);
            bytes += generator.row([
              PosColumn(
                text: 'Cantidad: ${item.cantidad}',
                width: 4,
                styles: PosStyles(
                  fontType: PosFontType.fontB,
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                containsChinese: false,
                text: 'Comp. de ${item.nombre}',
                width: 8,
                styles: PosStyles(
                  fontType: PosFontType.fontB,
                  align: PosAlign.right,
                ),
              ),
            ]);

            bytes += generator.text('-${complemento.complementoData.nombre}',
                styles: PosStyles(
                  bold: true,
                  fontType: PosFontType.fontA,
                  align: PosAlign.left,
                ));

            if (item.notaExtra!.isNotEmpty) {
              bytes += generator.text(' Nota orig:${item.notaExtra}',
                  styles: PosStyles(
                    underline: true,
                    fontType: PosFontType.fontB,
                    align: PosAlign.left,
                  ));
            }
          }
        }

        //EXTRA TAMAÑO COMPLETO
        for (var extra in item.listExtras!) {
          if (extra.cantidad > 0 && extra.extraData.imprimirSeparado == false) {
            bytes += generator.feed(1);
            bytes += generator.row([
              PosColumn(
                text: 'Cantidad: ${extra.cantidad * item.cantidad!}',
                width: 4,
                styles: PosStyles(
                  fontType: PosFontType.fontB,
                  align: PosAlign.left,
                ),
              ),
              PosColumn(
                containsChinese: false,
                text: 'Extra de ${item.nombre}',
                width: 8,
                styles: PosStyles(
                  fontType: PosFontType.fontB,
                  align: PosAlign.right,
                ),
              ),
            ]);

            bytes += generator.text('-${extra.extraData.nombre}',
                styles: PosStyles(
                  bold: true,
                  fontType: PosFontType.fontA,
                  align: PosAlign.left,
                ));

            if (item.notaExtra!.isNotEmpty) {
              bytes += generator.text(' Nota orig:${item.notaExtra}',
                  styles: PosStyles(
                    underline: true,
                    fontType: PosFontType.fontB,
                    align: PosAlign.left,
                  ));
            }
          }
        }
      }
    }

    bytes += generator.feed(2);
    bytes += generator.text('-----------------------------------------',
        styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center));
    bytes += generator.feed(1);

    return bytes;
  }
}
