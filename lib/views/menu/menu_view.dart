import 'package:allegro_saludable/views/menu/widgets/responsive_cards/responsive_cards_widget.dart';
import 'package:allegro_saludable/views/menu/widgets/tags/tags_widgets.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:allegro_saludable/views/menu/menu_provider.dart';
import 'package:allegro_saludable/widgets/widgets.dart';

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);

    return Scaffold(
      appBar: AppBarWidget(),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: ItemsSearch()),
          Container(
            padding: EdgeInsets.all(15),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined),
                    SpaceX(
                      percent: .5,
                    ),
                    TextNormal(
                      'Ver carrito (${orderService.ordenActual.itemsList!.length})',
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class ItemsSearch extends StatelessWidget {
  const ItemsSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    return LayoutBuilder(builder: ((context, constraints) {
      return ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SpaceY(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle('Nueva venta'),
                    Text('Seleccionar de inventario'),
                  ],
                ),
              ],
            ),
          ),
          SpaceY(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              decoration: InputDecoration(
                  isDense: false,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar en el menú'),
            ),
          ),
          SpaceY(),
          Container(
            width: double.infinity,
            height: 40,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              children: [for (var i = 0; i < 100; i++) TagsWidget()],
            ),
          ),
          SpaceY(),
          ...ResponisiveCards().getList(
              sm: 1,
              md: 2,
              lg: 4,
              xl: 5,
              xxl: 6,
              context: context,
              listCards: menuProvider.listProductos,
              currentSize: constraints.maxWidth)
        ],
      );
    }));
  }
}
