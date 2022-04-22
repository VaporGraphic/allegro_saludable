import 'package:allegro_saludable/models/caja/caja_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InformesCrudService extends ChangeNotifier {
  List<CajaModel> listCajas = [];

  int paginaActual = 0;

  int cantidadMaximaDocumentos = 2;

  bool cargandoInformes = false;

  //REFERENCIA FIREBASE
  CollectionReference cajaFirebaseReference =
      FirebaseFirestore.instance.collection('historialCajas');

  InformesCrudService() {
    obtenerInformes();
  }

  reiniciarInformes() {
    cantidadMaximaDocumentos = 0;
    listCajas = [];
    notifyListeners();
  }

  obtenerInformes() async {
    cargandoInformes = true;
    listCajas = [];
    notifyListeners();

    //print('Cantidad maxima ${paginaActual + cantidadMaximaDocumentos}');

    return cajaFirebaseReference
        .orderBy('fecha', descending: true)
        .limit(paginaActual + cantidadMaximaDocumentos)
        .get()
        .then((event) {
      final _listaDocumentos = event.docs;

      //print(_listaDocumentos.length);

      _listaDocumentos.map((e) => {});

      List<CajaModel> listCajasProv = _listaDocumentos.map((doc) {
        CajaModel corteCaja =
            CajaModel.fromMap(doc.data() as Map<String, dynamic>);

        corteCaja.firebaseId = doc.id;

        return corteCaja;
      }).toList();

      /*
      for (var caja in listCajasProv) {
        listCajas.add(caja);
      }*/

      listCajas = listCajasProv;

      cargandoInformes = false;
      notifyListeners();

      print('Actualizacion de cajas obtenida');
    }).catchError((error) {});
  }

  cargarMasInformes() {
    cargandoInformes = true;

    //print('Cantidad maxima ${paginaActual + cantidadMaximaDocumentos}');

    return cajaFirebaseReference
        .orderBy('fecha', descending: true)
        .startAfter(
            [listCajas[listCajas.length - 1].fecha!.millisecondsSinceEpoch])
        .limit(paginaActual + cantidadMaximaDocumentos)
        .get()
        .then((event) {
          final _listaDocumentos = event.docs;

          //print(_listaDocumentos.length);

          _listaDocumentos.map((e) => {});

          List<CajaModel> listCajasProv = _listaDocumentos.map((doc) {
            CajaModel corteCaja =
                CajaModel.fromMap(doc.data() as Map<String, dynamic>);

            corteCaja.firebaseId = doc.id;

            return corteCaja;
          }).toList();

          for (var caja in listCajasProv) {
            listCajas.add(caja);
          }

          cargandoInformes = false;
          notifyListeners();

          print('Actualizacion de cajas obtenida');
        })
        .catchError((error) {});
  }
}
