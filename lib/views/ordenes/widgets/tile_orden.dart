import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';

class TileOrden extends StatelessWidget {
  final VoidCallback onTap;

  final String nombre;
  final String estado;
  final String hora;
  final DateTime fecha;
  final bool envio;
  final double total;

  const TileOrden({
    Key? key,
    required this.onTap,
    required this.nombre,
    required this.estado,
    required this.hora,
    required this.envio,
    required this.total,
    required this.fecha,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.5),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextSmall(
                              '${fecha.day}/${fecha.month}/${fecha.year}',
                              color: Colors.grey,
                            ),
                            estado == 'cancelado'
                                ? EstadoInk(estado)
                                : Container()
                          ],
                        ),
                        TextNormal(
                          '$nombre',
                        ),
                      ],
                    )),
                  ],
                ),
                SpaceY(
                  percent: .5,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Ink(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 15,
                              ),
                              SpaceX(
                                percent: .25,
                              ),
                              TextSmall('$hora')
                            ],
                          ),
                        ),
                        SpaceX(
                          percent: .5,
                        ),
                        Ink(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey)),
                          child: envio == false
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.storefront,
                                      size: 15,
                                    ),
                                    SpaceX(
                                      percent: .25,
                                    ),
                                    TextSmall('Local')
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.pedal_bike_outlined,
                                      size: 15,
                                    ),
                                    SpaceX(
                                      percent: .25,
                                    ),
                                    TextSmall('Envio')
                                  ],
                                ),
                        ),
                      ],
                    )),
                    TextNormal(
                      '\$$total',
                      fontWeight: FontWeight.bold,
                      color: estado == 'cancelado' ? Colors.grey : Colors.black,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Ink EstadoInk(String estado) {
    return Ink(
      child: TextSmall(
        'Cancelado',
        color: Colors.grey,
      ),
    );
  }
}
