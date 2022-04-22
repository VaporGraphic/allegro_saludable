import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderCrudService extends ChangeNotifier {
  //REFERENCIA FIREBASE
  CollectionReference inventarioFirebaseReference =
      FirebaseFirestore.instance.collection('inventario');

  abirPaginaExito() {}
}
