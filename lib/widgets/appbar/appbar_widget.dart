import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/widgets/appbar/appbar_provider.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;

  AppBarWidget({
    this.title,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final clockService = Provider.of<ClockService>(context);

    return AppBar(
      centerTitle: true,
      title: title != null ? Text(title!) : Text(clockService.dateTimeString),
      leading: leading,
      actions: actions,
    );
  }
}
