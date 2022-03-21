import 'dart:convert';

class CategoriaModel {
  String? firebaseId;
  String nombre;
  CategoriaModel({
    this.firebaseId,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'firebaseId': firebaseId,
      'nombre': nombre,
    };
  }

  factory CategoriaModel.fromMap(Map<String, dynamic> map) {
    return CategoriaModel(
      firebaseId: map['firebaseId'],
      nombre: map['nombre'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriaModel.fromJson(String source) =>
      CategoriaModel.fromMap(json.decode(source));
}

class ProductoModel {
  String? firebaseId;
  String icono;
  String nombre;
  bool switchMultiple;
  CategoriaModel categoriaModel;
  List<VariacionModel> listVariaciones;
  List<ComplementosModel> listComplementos;
  List<ExtrasModel> listExtras;

  ProductoModel({
    this.firebaseId,
    required this.icono,
    required this.nombre,
    required this.switchMultiple,
    required this.categoriaModel,
    required this.listVariaciones,
    required this.listComplementos,
    required this.listExtras,
  });

  Map<String, dynamic> toMap() {
    return {
      'firebaseId': firebaseId,
      'icono': icono,
      'nombre': nombre,
      'switchMultiple': switchMultiple,
      'categoriaModel': categoriaModel.toMap(),
      'listVariaciones': listVariaciones.map((x) => x.toMap()).toList(),
      'listComplementos': listComplementos.map((x) => x.toMap()).toList(),
      'listExtras': listExtras.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      firebaseId: map['firebaseId'],
      icono: map['icono'] ?? '',
      nombre: map['nombre'] ?? '',
      switchMultiple: map['switchMultiple'] ?? false,
      categoriaModel: CategoriaModel.fromMap(map['categoriaModel']),
      listVariaciones: List<VariacionModel>.from(
          map['listVariaciones']?.map((x) => VariacionModel.fromMap(x))),
      listComplementos: List<ComplementosModel>.from(
          map['listComplementos']?.map((x) => ComplementosModel.fromMap(x))),
      listExtras: List<ExtrasModel>.from(
          map['listExtras']?.map((x) => ExtrasModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductoModel.fromJson(String source) =>
      ProductoModel.fromMap(json.decode(source));
}

class VariacionModel {
  String subnombre;
  String codigo;
  int stock;
  double precio;

  VariacionModel({
    required this.subnombre,
    required this.codigo,
    required this.stock,
    required this.precio,
  });

  Map<String, dynamic> toMap() {
    return {
      'subnombre': subnombre,
      'codigo': codigo,
      'stock': stock,
      'precio': precio,
    };
  }

  factory VariacionModel.fromMap(Map<String, dynamic> map) {
    return VariacionModel(
      subnombre: map['subnombre'] ?? '',
      codigo: map['codigo'] ?? '',
      stock: map['stock']?.toInt() ?? 0,
      precio: map['precio']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VariacionModel.fromJson(String source) =>
      VariacionModel.fromMap(json.decode(source));
}

class ComplementosModel {
  bool imprimirSeparado;
  String nombre;
  CategoriaModel categoria;

  ComplementosModel({
    required this.imprimirSeparado,
    required this.nombre,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'imprimirSeparado': imprimirSeparado,
      'nombre': nombre,
      'categoria': categoria.toMap(),
    };
  }

  factory ComplementosModel.fromMap(Map<String, dynamic> map) {
    return ComplementosModel(
      imprimirSeparado: map['imprimirSeparado'] ?? false,
      nombre: map['nombre'] ?? '',
      categoria: CategoriaModel.fromMap(map['categoria']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplementosModel.fromJson(String source) =>
      ComplementosModel.fromMap(json.decode(source));
}

class ExtrasModel {
  bool imprimirSeparado;
  String nombre;
  double precio;
  CategoriaModel categoria;
  ExtrasModel({
    required this.imprimirSeparado,
    required this.nombre,
    required this.precio,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'imprimirSeparado': imprimirSeparado,
      'nombre': nombre,
      'precio': precio,
      'categoria': categoria.toMap(),
    };
  }

  factory ExtrasModel.fromMap(Map<String, dynamic> map) {
    return ExtrasModel(
      imprimirSeparado: map['imprimirSeparado'] ?? false,
      nombre: map['nombre'] ?? '',
      precio: map['precio']?.toDouble() ?? 0.0,
      categoria: CategoriaModel.fromMap(map['categoria']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExtrasModel.fromJson(String source) =>
      ExtrasModel.fromMap(json.decode(source));
}
