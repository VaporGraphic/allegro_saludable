import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool selected;

  const ExpandedButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Ink(
        decoration: BoxDecoration(
            color: selected == false
                ? Colors.grey.shade100
                : Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Icon(
                    icon,
                    color:
                        selected == false ? Colors.grey.shade600 : Colors.white,
                  ),
                  SpaceX(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextNormal(
                        '$title',
                        color: selected == false ? Colors.black : Colors.white,
                      ),
                      TextSmall(
                        '$subtitle',
                        color: selected == false
                            ? Colors.grey
                            : Color.fromARGB(255, 203, 187, 207),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
