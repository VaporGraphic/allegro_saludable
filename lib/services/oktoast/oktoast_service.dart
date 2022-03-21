import 'package:allegro_saludable/widgets/spacing/space_widgets.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class OkToastService extends ChangeNotifier {
  showOkToast({required String mensaje, int? duration}) {
    showToastWidget(
      Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade900.withOpacity(.90)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$mensaje',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
      position: ToastPosition.top,
      duration: Duration(seconds: duration == null ? 2 : duration),
    );
  }
}
