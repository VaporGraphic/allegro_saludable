import 'dart:convert';

import 'package:allegro_saludable/models/models.dart';

class ItemCartModel {
  int? cantidad;
  String? icono;
  String? nombre;
  VariacionModel? modeloSeleccionado;
  List<ComplementosSeleccionados>? listComplementos;
  List<ExtrasSeleccionados>? listExtras;
  String? notaExtra;
  double? extrasPrecio;
  double? subTotalPrecio;
  double? totalPrecio;

  ItemCartModel({
    this.cantidad,
    this.icono,
    this.nombre,
    this.modeloSeleccionado,
    this.listComplementos,
    this.listExtras,
    this.notaExtra,
    this.extrasPrecio,
    this.subTotalPrecio,
    this.totalPrecio,
  });

  Map<String, dynamic> toMap() {
    return {
      'cantidad': cantidad,
      'icono': icono,
      'nombre': nombre,
      'modeloSeleccionado': modeloSeleccionado?.toMap(),
      'listComplementos': listComplementos?.map((x) => x.toMap()).toList(),
      'listExtras': listExtras?.map((x) => x.toMap()).toList(),
      'notaExtra': notaExtra,
      'extrasPrecio': extrasPrecio,
      'subTotalPrecio': subTotalPrecio,
      'totalPrecio': totalPrecio,
    };
  }

  factory ItemCartModel.fromMap(Map<String, dynamic> map) {
    return ItemCartModel(
      cantidad: map['cantidad']?.toInt(),
      icono: map['icono'],
      nombre: map['nombre'],
      modeloSeleccionado: map['modeloSeleccionado'] != null
          ? VariacionModel.fromMap(map['modeloSeleccionado'])
          : null,
      listComplementos: map['listComplementos'] != null
          ? List<ComplementosSeleccionados>.from(map['listComplementos']
              ?.map((x) => ComplementosSeleccionados.fromMap(x)))
          : null,
      listExtras: map['listExtras'] != null
          ? List<ExtrasSeleccionados>.from(
              map['listExtras']?.map((x) => ExtrasSeleccionados.fromMap(x)))
          : null,
      notaExtra: map['notaExtra'],
      extrasPrecio: map['extrasPrecio']?.toDouble(),
      subTotalPrecio: map['subTotalPrecio']?.toDouble(),
      totalPrecio: map['totalPrecio']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCartModel.fromJson(String source) =>
      ItemCartModel.fromMap(json.decode(source));
}

class ComplementosSeleccionados {
  ComplementosModel complementoData;
  bool seleccionado;

  ComplementosSeleccionados({
    required this.complementoData,
    required this.seleccionado,
  });

  Map<String, dynamic> toMap() {
    return {
      'complementoData': complementoData.toMap(),
      'seleccionado': seleccionado,
    };
  }

  factory ComplementosSeleccionados.fromMap(Map<String, dynamic> map) {
    return ComplementosSeleccionados(
      complementoData: ComplementosModel.fromMap(map['complementoData']),
      seleccionado: map['seleccionado'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplementosSeleccionados.fromJson(String source) =>
      ComplementosSeleccionados.fromMap(json.decode(source));
}

class ExtrasSeleccionados {
  ExtrasModel extraData;
  int cantidad;
  double subtotal;

  ExtrasSeleccionados({
    required this.extraData,
    required this.cantidad,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'extraData': extraData.toMap(),
      'cantidad': cantidad,
      'subtotal': subtotal,
    };
  }

  factory ExtrasSeleccionados.fromMap(Map<String, dynamic> map) {
    return ExtrasSeleccionados(
      extraData: ExtrasModel.fromMap(map['extraData']),
      cantidad: map['cantidad']?.toInt() ?? 0,
      subtotal: map['subtotal']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExtrasSeleccionados.fromJson(String source) =>
      ExtrasSeleccionados.fromMap(json.decode(source));
}
