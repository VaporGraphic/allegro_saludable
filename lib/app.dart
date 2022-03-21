import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

class AllegroSaludableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PaymentProvider>(
              create: (_) => PaymentProvider()),
          ChangeNotifierProvider<MenuProvider>(create: (_) => MenuProvider()),
          ChangeNotifierProvider<PaymentCajaProvider>(
              create: (_) => PaymentCajaProvider()),
          ChangeNotifierProvider<OkToastService>(
              create: (_) => OkToastService()),
          ChangeNotifierProvider<OrderService>(create: (_) => OrderService()),
          ChangeNotifierProvider<AppbarProvider>(
              create: (_) => AppbarProvider()),
          ChangeNotifierProvider<ClockService>(create: (_) => ClockService()),
          ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
          ChangeNotifierProvider<ProductSelectorProvider>(
              create: (_) => ProductSelectorProvider()),
        ],
        child: OKToast(
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Allegro Saludable',
              theme: ThemeData(
                dialogTheme: DialogTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.5))),
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(.5)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      gapPadding: 1,
                      borderSide: BorderSide()),
                ),
                useMaterial3: true,
                fontFamily: 'Poppins',
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurpleAccent,
                    secondary: Colors.black,
                    tertiary: Colors.red,
                    tertiaryContainer: Colors.red,
                    secondaryContainer: Colors.red),
                scaffoldBackgroundColor: Color.fromARGB(255, 253, 253, 253),
                appBarTheme: AppBarTheme(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0),
                textButtonTheme: TextButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(21),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                outlinedButtonTheme: OutlinedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(21),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(21),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
              ),
              initialRoute: '/menu',
              routes: {
                '/menu': (context) => const MenuView(),
                '/cart': (context) => const CartView(),
              }),
        ));
  }
}
