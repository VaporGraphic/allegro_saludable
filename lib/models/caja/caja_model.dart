import 'dart:convert';

import 'package:allegro_saludable/models/models.dart';

class CajaModel {
  String? firebaseId;
  DateTime? fecha;
  double? dineroInicial;
  List<OrderModel>? listOrdenes;
  List<PagoServicioModel>? listPagos;
  double? subtotalOrdenes;
  double? subtotalPagos;
  double? total;
  CajaModel({
    this.firebaseId,
    this.fecha,
    this.dineroInicial,
    this.listOrdenes,
    this.listPagos,
    this.subtotalOrdenes,
    this.subtotalPagos,
    this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'firebaseId': firebaseId,
      'fecha': fecha?.millisecondsSinceEpoch,
      'dineroInicial': dineroInicial,
      'listOrdenes': listOrdenes?.map((x) => x.toMap()).toList(),
      'listPagos': listPagos?.map((x) => x.toMap()).toList(),
      'subtotalOrdenes': subtotalOrdenes,
      'subtotalPagos': subtotalPagos,
      'total': total,
    };
  }

  factory CajaModel.fromMap(Map<String, dynamic> map) {
    return CajaModel(
      firebaseId: map['firebaseId'],
      fecha: map['fecha'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fecha'])
          : null,
      dineroInicial: map['dineroInicial']?.toDouble(),
      listOrdenes: map['listOrdenes'] != null
          ? List<OrderModel>.from(
              map['listOrdenes']?.map((x) => OrderModel.fromMap(x)))
          : null,
      listPagos: map['listPagos'] != null
          ? List<PagoServicioModel>.from(
              map['listPagos']?.map((x) => PagoServicioModel.fromMap(x)))
          : null,
      subtotalOrdenes: map['subtotalOrdenes']?.toDouble(),
      subtotalPagos: map['subtotalPagos']?.toDouble(),
      total: map['total']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CajaModel.fromJson(String source) =>
      CajaModel.fromMap(json.decode(source));
}
