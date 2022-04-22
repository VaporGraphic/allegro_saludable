import 'dart:convert';

class PagoServicioModel {
  String? firebaseId;
  bool cancelado = false;
  DateTime? fecha;
  String? motivo;
  double? totalPrecio;

  PagoServicioModel({
    this.firebaseId,
    required this.cancelado,
    this.fecha,
    this.motivo,
    this.totalPrecio,
  });

  Map<String, dynamic> toMap() {
    return {
      'firebaseId': firebaseId,
      'cancelado': cancelado,
      'fecha': fecha?.millisecondsSinceEpoch,
      'motivo': motivo,
      'totalPrecio': totalPrecio,
    };
  }

  factory PagoServicioModel.fromMap(Map<String, dynamic> map) {
    return PagoServicioModel(
      firebaseId: map['firebaseId'],
      cancelado: map['cancelado'] ?? false,
      fecha: map['fecha'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fecha'])
          : null,
      motivo: map['motivo'],
      totalPrecio: map['totalPrecio']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PagoServicioModel.fromJson(String source) =>
      PagoServicioModel.fromMap(json.decode(source));
}
