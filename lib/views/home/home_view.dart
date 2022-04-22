import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabsProvider = Provider.of<TabsProvider>(context);

    return Scaffold(
      appBar: AppBarWidget(),
      body: ListView(
        padding: EdgeInsets.all(15),
        physics: BouncingScrollPhysics(),
        children: [
          TextTitle('Allegro Saludable'),
          Text('Bienvenido ¿Qué deseas hacer hoy?'),
          SpaceY(),
          SpaceY(),
          Row(
            children: [
              ButtonTile(
                onTap: () {
                  tabsProvider.cambiarTab(1);
                },
                icon: Icons.menu_book_rounded,
                title: 'Ver menú',
                details: 'Hacer nueva venta',
                color: Colors.indigoAccent,
              ),
              SpaceX(
                percent: .5,
              ),
              ButtonTile(
                onTap: () {
                  tabsProvider.cambiarTab(2);
                },
                icon: Icons.history_outlined,
                title: 'Ver ordenes',
                details: 'Lista de ordenes',
                color: Colors.deepOrangeAccent,
              )
            ],
          ),
          SpaceY(
            percent: .5,
          ),
          Row(
            children: [
              ButtonTile(
                onTap: () {
                  Navigator.pushNamed(context, '/pagos');
                },
                icon: Icons.payments_outlined,
                title: 'Hacer pago',
                details: 'Pagar de servicios',
                color: Colors.green,
              ),
              SpaceX(
                percent: .5,
              ),
              ButtonTile(
                onTap: () {
                  Navigator.pushNamed(context, '/informes');
                },
                icon: Icons.insert_chart_outlined_outlined,
                title: 'Ver informes',
                details: 'Listado de informes',
                color: Color.fromARGB(255, 255, 168, 7),
              )
            ],
          ),
          SpaceY(
            percent: .5,
          ),
        ],
      ),
    );
  }
}

class ButtonTile extends StatelessWidget {
  final bool inverted;
  final VoidCallback onTap;
  final String title;
  final String details;
  final IconData icon;
  final Color color;

  const ButtonTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.details,
    required this.icon,
    required this.color,
    this.inverted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: color),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: inverted == false ? Colors.white : Colors.black,
                ),
                SpaceY(),
                TextLead(
                  '$title',
                  color: inverted == false ? Colors.white : Colors.black,
                  maxLines: 1,
                ),
                TextSmall(
                  '$details',
                  color: inverted == false ? Colors.white : Colors.black,
                  maxLines: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
