import 'package:flutter/material.dart';

class SpaceX extends StatelessWidget {
  final double? percent;
  const SpaceX({Key? key, this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: percent == null ? 15 : 15 * percent!,
    );
  }
}

class SpaceY extends StatelessWidget {
  final double? percent;
  const SpaceY({Key? key, this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: percent == null ? 15 : 15 * percent!,
    );
  }
}
