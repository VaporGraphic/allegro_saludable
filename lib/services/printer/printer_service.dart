import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:open_settings/open_settings.dart';

class PrinterService extends ChangeNotifier {
  comprobarBluetooth(BuildContext context) async {
    bool estaActivado = await PrintBluetoothThermal.bluetoothEnabled;

    if (estaActivado == true) {
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Bluetooth desactivado'),
              content: Text('Enciende el bluetooth para imprimir ticket'),
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
}
