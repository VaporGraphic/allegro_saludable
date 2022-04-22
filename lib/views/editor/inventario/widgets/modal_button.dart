import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ModalButton extends StatelessWidget {
  final String title;
  final String selectedTitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const ModalButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.selected,
    required this.selectedTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17.5),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey.shade600,
              ),
              SpaceX(),
              Expanded(
                  child: Text(
                selected == false ? '$title' : '$selectedTitle',
                style: TextStyle(
                    fontSize: 15.5,
                    color: selected == false
                        ? Colors.grey.shade700
                        : Colors.deepPurpleAccent),
              )),
              Icon(
                Icons.arrow_drop_up_outlined,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade400)),
    );
  }
}
