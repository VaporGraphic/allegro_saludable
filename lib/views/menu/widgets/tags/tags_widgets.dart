import 'package:flutter/material.dart';

class TagsWidget extends StatelessWidget {
  const TagsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7.5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Ink(
            padding: EdgeInsets.all(7.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey)),
            child: Text('Categoria'),
          ),
        ),
      ),
    );
  }
}
