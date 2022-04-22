import 'dart:convert';

import 'package:allegro_saludable/models/models.dart';

class OrderModel {
  String? firebaseId;
  String? cliente;
  String? estadoPedido;
  bool? switchEnvio;
  String? ubicacion;
  String? ubicacionLocal;
  int? numero;
  bool? switchTarjeta;
  double? efectivoRecibido;
  double? cambioEntregado;
  String? referenciaTarjeta;
  DateTime? fecha;

  List<ItemCartModel>? itemsList;
  double? subtotalPrecio;
  double? envioPrecio;
  double? totalPrecio;

  OrderModel({
    this.firebaseId,
    this.cliente,
    this.estadoPedido,
    this.switchEnvio,
    this.ubicacion,
    this.ubicacionLocal,
    this.numero,
    this.switchTarjeta,
    this.efectivoRecibido,
    this.cambioEntregado,
    this.referenciaTarjeta,
    this.fecha,
    this.itemsList,
    this.subtotalPrecio,
    this.envioPrecio,
    this.totalPrecio,
  });

  Map<String, dynamic> toMap() {
    return {
      'firebaseId': firebaseId,
      'cliente': cliente,
      'estadoPedido': estadoPedido,
      'switchEnvio': switchEnvio,
      'ubicacion': ubicacion,
      'ubicacionLocal': ubicacionLocal,
      'numero': numero,
      'switchTarjeta': switchTarjeta,
      'efectivoRecibido': efectivoRecibido,
      'cambioEntregado': cambioEntregado,
      'codigoTarjeta': referenciaTarjeta,
      'fecha': fecha?.millisecondsSinceEpoch,
      'itemsList': itemsList?.map((x) => x.toMap()).toList(),
      'subtotalPrecio': subtotalPrecio,
      'envioPrecio': envioPrecio,
      'totalPrecio': totalPrecio,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      firebaseId: map['firebaseId'],
      cliente: map['cliente'],
      estadoPedido: map['estadoPedido'],
      switchEnvio: map['switchEnvio'],
      ubicacion: map['ubicacion'],
      ubicacionLocal: map['ubicacionLocal'],
      numero: map['numero']?.toInt(),
      switchTarjeta: map['switchTarjeta'],
      efectivoRecibido: map['efectivoRecibido']?.toDouble(),
      cambioEntregado: map['cambioEntregado']?.toDouble(),
      referenciaTarjeta: map['codigoTarjeta'],
      fecha: map['fecha'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fecha'])
          : null,
      itemsList: map['itemsList'] != null
          ? List<ItemCartModel>.from(
              map['itemsList']?.map((x) => ItemCartModel.fromMap(x)))
          : null,
      subtotalPrecio: map['subtotalPrecio']?.toDouble(),
      envioPrecio: map['envioPrecio']?.toDouble(),
      totalPrecio: map['totalPrecio']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
