import 'package:allegro_saludable/models/models.dart';
import 'package:flutter/material.dart';

class ProductSelectorProvider extends ChangeNotifier {
  //VARIABLES EDITOR
  ItemCartModel itemCartModel = ItemCartModel();

  //VARIABLES UI
  bool switchResumen = false;
  int? indexEditable = null;
  TextEditingController comentariosController = TextEditingController();

  editarModelo(ItemCartModel modelo, int index) {
    indexEditable = index;
    switchResumen = true;
    itemCartModel = modelo;
    comentariosController.text = modelo.notaExtra!;
  }

  establecerModelo(ProductoModel modelo, VariacionModel variacionSeleccionado) {
    indexEditable = null;

    switchResumen = false;

    comentariosController.clear();

    List<ComplementosSeleccionados> listComplementos = [];
    List<ExtrasSeleccionados> listExtras = [];

    for (var complemento in modelo.listComplementos) {
      ComplementosSeleccionados complementoProvicional =
          ComplementosSeleccionados(
              seleccionado: true, complementoData: complemento);
      listComplementos.add(complementoProvicional);
    }

    for (var extra in modelo.listExtras) {
      ExtrasSeleccionados complementoProvicional =
          ExtrasSeleccionados(cantidad: 0, extraData: extra, subtotal: 0);
      listExtras.add(complementoProvicional);
    }

    itemCartModel = ItemCartModel(
        categoria: modelo.categoriaModel,
        cantidad: 1,
        icono: modelo.icono,
        nombre: modelo.nombre,
        modeloSeleccionado: variacionSeleccionado,
        listComplementos: listComplementos,
        listExtras: listExtras,
        notaExtra: '',
        extrasPrecio: 0,
        subTotalPrecio: variacionSeleccionado.precio,
        totalPrecio: variacionSeleccionado.precio);

    notifyListeners();
  }

  //------------ COMPLEMENTOS ------------

  seleccionarComplemento(bool value, int index) {
    itemCartModel.listComplementos![index].seleccionado = value;
    actualizarPrecio();
  }

  //------------ EXTRAS ------------

  sumarExtra(int index) {
    itemCartModel.listExtras![index].cantidad++;
    itemCartModel.listExtras![index].subtotal =
        itemCartModel.listExtras![index].extraData.precio *
            itemCartModel.listExtras![index].cantidad;
    actualizarPrecio();
  }

  restarExtra(int index) {
    if (itemCartModel.listExtras![index].cantidad > 0) {
      itemCartModel.listExtras![index].cantidad--;
      itemCartModel.listExtras![index].subtotal =
          itemCartModel.listExtras![index].extraData.precio *
              itemCartModel.listExtras![index].cantidad;
    }
    actualizarPrecio();
  }

  //------------ NOTA EXTRA ------------

  editarComentario(String value) {
    itemCartModel.notaExtra = value;
    actualizarPrecio();
  }

  //------------ CANTIDAD PRODUCTOS ------------

  sumarProducto() {
/*    if (itemCartModel.cantidad! < itemCartModel.modeloSeleccionado!.stock) {
      itemCartModel.cantidad = itemCartModel.cantidad! + 1;
    } */
    itemCartModel.cantidad = itemCartModel.cantidad! + 1;

    actualizarPrecio();
  }

  restarProducto() {
    if (itemCartModel.cantidad! > 1) {
      itemCartModel.cantidad = itemCartModel.cantidad! - 1;
    }
    actualizarPrecio();
  }

  //------------ CANTIDAD PRODUCTOS ------------

  actualizarPrecio() {
    //EXTRAS SUBTOTAL
    itemCartModel.extrasPrecio = 0;
    for (var extra in itemCartModel.listExtras!) {
      itemCartModel.extrasPrecio = itemCartModel.extrasPrecio! + extra.subtotal;
    }

    //SUBTOTAL PRODUCTOS
    itemCartModel.subTotalPrecio =
        itemCartModel.extrasPrecio! + itemCartModel.modeloSeleccionado!.precio;

    //TOTAL
    itemCartModel.totalPrecio =
        itemCartModel.subTotalPrecio! * itemCartModel.cantidad!;

    notifyListeners();
  }

  //------------ RESUMEN PRODUCTOS ------------

  toggleResumen() {
    switchResumen = !switchResumen;
    notifyListeners();
  }

  //------------ REGRESAR ------------

  backButton(BuildContext context) {
    if (switchResumen == true) {
      toggleResumen();
    } else {
      Navigator.pop(context);
    }
  }
}
