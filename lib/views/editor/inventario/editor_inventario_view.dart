import 'package:allegro_saludable/views/editor/inventario/widgets/modal_button.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/widgets/appbar/appbar_widget.dart';
import 'package:allegro_saludable/widgets/spacing/space_widgets.dart';
import 'package:allegro_saludable/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditorInventarioView extends StatelessWidget {
  const EditorInventarioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editorInventarioProvider =
        Provider.of<EditorInventarioProvider>(context);

    final List<Widget> listSingle = [
      TextField(
        controller: editorInventarioProvider.codigoController,
        decoration: InputDecoration(
            hintText: 'Codigo del producto',
            prefixIcon: Icon(Icons.view_in_ar_rounded)),
      ),
      SpaceY(),
      TextField(
        controller: editorInventarioProvider.nombreController,
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            prefixIcon: Icon(Icons.border_color_outlined)),
      ),
      SpaceY(),
      TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        ],
        keyboardType: TextInputType.number,
        controller: editorInventarioProvider.precioController,
        decoration: InputDecoration(
            hintText: 'Precio del producto',
            prefixIcon: Icon(Icons.payments_outlined)),
      ),
      SpaceY(),
      TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        controller: editorInventarioProvider.stockController,
        decoration: InputDecoration(
            suffixIcon: Switch(
                value: editorInventarioProvider.productoEditable.switchStock,
                onChanged: (value) {
                  editorInventarioProvider.toogleStock(value);
                }),
            hintText: 'Stock disponible',
            prefixIcon: Icon(Icons.all_inbox_outlined)),
      ),
    ];

    final List<Widget> listMultiple = [
      TextField(
        controller: editorInventarioProvider.nombreController,
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            prefixIcon: Icon(Icons.border_color_outlined)),
      ),
      SpaceY(),
      Ink(
        child: InkWell(
          onTap: () {
            editorInventarioProvider.abrirVariaciones(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17.5),
            child: Row(
              children: [
                Icon(
                  Icons.layers_outlined,
                  color: Colors.grey.shade600,
                ),
                SpaceX(),
                Expanded(
                    child: Text(
                  editorInventarioProvider
                          .productoEditable.listVariaciones.isEmpty
                      ? 'Editar modelos'
                      : '(${editorInventarioProvider.productoEditable.listVariaciones.length}) Editar modelos',
                  style: TextStyle(
                      fontSize: 15.5,
                      color: editorInventarioProvider
                              .productoEditable.listVariaciones.isEmpty
                          ? Colors.grey.shade700
                          : Colors.deepPurpleAccent),
                )),
                Icon(
                  Icons.arrow_right_outlined,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade400)),
      )
    ];

    return Scaffold(
      appBar: AppBarWidget(
        title: editorInventarioProvider.switchEditable == false
            ? 'Crear producto'
            : 'Editar producto',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(15),
              children: [
                TextTitle('Nuevo producto'),
                Text('Datos del producto'),
                SpaceY(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 150,
                      height: 150,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          editorInventarioProvider.seleccionarIcono(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: editorInventarioProvider
                                  .productoEditable.icono.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.photo_camera_outlined),
                                    TextSmall('Seleccionar icono'),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Image(
                                      image: AssetImage(
                                          'assets/icons/${editorInventarioProvider.productoEditable.icono}.png')),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
                SpaceY(),
                SwitchListTile(
                    title: Text('Tiene multiples modelos'),
                    value: editorInventarioProvider
                        .productoEditable.switchMultiple,
                    onChanged: (value) {
                      editorInventarioProvider.toogleMultiple(value);
                    }),
                SpaceY(),
                if (editorInventarioProvider.productoEditable.switchMultiple ==
                    false)
                  ...listSingle
                else
                  ...listMultiple,
                SpaceY(),
                ModalButton(
                    selectedTitle:
                        editorInventarioProvider.productoEditable.unidad,
                    selected: editorInventarioProvider
                        .productoEditable.unidad.isNotEmpty,
                    onTap: () {
                      editorInventarioProvider.showModalUnidad(context);
                    },
                    title: 'Tipo de unidad',
                    icon: Icons.category_outlined),
                SpaceY(),
                ModalButton(
                    selectedTitle: editorInventarioProvider
                        .productoEditable.categoriaModel.nombre,
                    selected: editorInventarioProvider
                        .productoEditable.categoriaModel.nombre.isNotEmpty,
                    onTap: () {
                      editorInventarioProvider.showModalCategoria(context);
                    },
                    title: 'Categoria',
                    icon: Icons.sell_outlined),
                SpaceY(),
                Text('Extras'),
                SpaceY(),
                ListTile(
                  onTap: () {
                    editorInventarioProvider.abrirExtras(context);
                  },
                  title: TextNormal(
                    '(${editorInventarioProvider.productoEditable.listExtras.length}) Extras',
                    color: Colors.deepPurpleAccent,
                  ),
                  trailing: Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                SpaceY(),
                Text('Complementos'),
                SpaceY(),
                ListTile(
                  onTap: () {
                    editorInventarioProvider.abrirComplementos(context);
                  },
                  title: TextNormal(
                    '(${editorInventarioProvider.productoEditable.listComplementos.length}) Complementos',
                    color: Colors.deepPurpleAccent,
                  ),
                  trailing: Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  editorInventarioProvider.guardarModelo(context);
                },
                child: TextNormal(
                  editorInventarioProvider.switchEditable == false
                      ? 'Crear producto'
                      : 'Guardar cambios',
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
    );
  }
}
