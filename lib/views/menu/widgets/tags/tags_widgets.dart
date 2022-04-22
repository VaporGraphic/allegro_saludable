import 'package:allegro_saludable/views/views.dart';
import 'package:flutter/material.dart';

class TagsWidget extends StatelessWidget {
  final bool isSelected;
  final bool isVisible;
  final String nombre;

  final VoidCallback onTap;

  const TagsWidget(
      {Key? key,
      required this.isSelected,
      required this.isVisible,
      required this.onTap,
      required this.nombre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible == true
        ? Padding(
            padding: const EdgeInsets.only(right: 7.5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onTap,
                child: Ink(
                  padding:
                      EdgeInsets.symmetric(vertical: 7.5, horizontal: 11.25),
                  decoration: BoxDecoration(
                      color: isSelected == true
                          ? Colors.deepPurpleAccent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                    children: [
                      isSelected == true
                          ? Padding(
                              padding: const EdgeInsets.only(right: 3.5),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15,
                              ),
                            )
                          : Container(),
                      TextNormal(
                        nombre,
                        fontWeight: isSelected == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected == true ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            width: 0,
          );
  }
}
