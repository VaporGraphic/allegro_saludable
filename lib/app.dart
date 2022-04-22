import 'package:allegro_saludable/services/firebase/inventario/inventario_crud_service.dart';
import 'package:allegro_saludable/services/oktoast/oktoast_service.dart';
import 'package:allegro_saludable/services/services.dart';
import 'package:allegro_saludable/views/ajustes/subpages/usuarios/subpages/ajustes_usuarios_edit_provider.dart';
import 'package:allegro_saludable/views/editor/inventario/subpages/complementos/editor_inventario_complementos_provider.dart';
import 'package:allegro_saludable/views/pagos/pagos_provider.dart';
import 'package:allegro_saludable/views/pagos/pagos_view.dart';
import 'package:allegro_saludable/views/providers.dart';
import 'package:allegro_saludable/views/tabs/tabs_view.dart';
import 'package:allegro_saludable/views/views.dart';
import 'package:allegro_saludable/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

class AllegroSaludableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PaymentProvider>(
              create: (_) => PaymentProvider()),
          ChangeNotifierProvider<MenuProvider>(create: (_) => MenuProvider()),
          ChangeNotifierProvider<InformesCrudService>(
              create: (_) => InformesCrudService()),
          ChangeNotifierProvider<InformesInfoProvider>(
              create: (_) => InformesInfoProvider()),
          ChangeNotifierProvider<PagosProvider>(create: (_) => PagosProvider()),
          ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
          ChangeNotifierProvider<AjustesUsuariosEditProvider>(
              create: (_) => AjustesUsuariosEditProvider()),
          ChangeNotifierProvider<AjustesUsuariosProvider>(
              create: (_) => AjustesUsuariosProvider()),
          ChangeNotifierProvider<InformesProvider>(
              create: (_) => InformesProvider()),
          ChangeNotifierProvider<UsuariosCrudService>(
              create: (_) => UsuariosCrudService()),
          ChangeNotifierProvider<OrdenesEditorProvider>(
              create: (_) => OrdenesEditorProvider()),
          ChangeNotifierProvider<PaymentSuccessProvider>(
              create: (_) => PaymentSuccessProvider()),
          ChangeNotifierProvider<OrdenesProvider>(
              create: (_) => OrdenesProvider()),
          ChangeNotifierProvider<CajaCrudService>(
              create: (_) => CajaCrudService()),
          ChangeNotifierProvider<AjustesPrinterProvider>(
              create: (_) => AjustesPrinterProvider()),
          ChangeNotifierProvider<InventarioCrudService>(
              create: (_) => InventarioCrudService()),
          ChangeNotifierProvider<EditorInventarioVariacionesProvider>(
              create: (_) => EditorInventarioVariacionesProvider()),
          ChangeNotifierProvider<EditorInventarioComplementosProvider>(
              create: (_) => EditorInventarioComplementosProvider()),
          ChangeNotifierProvider<EditorInventarioExtrasProvider>(
              create: (_) => EditorInventarioExtrasProvider()),
          ChangeNotifierProvider<EditorInventarioProvider>(
              create: (_) => EditorInventarioProvider()),
          ChangeNotifierProvider<AjustesInventarioProvider>(
              create: (_) => AjustesInventarioProvider()),
          ChangeNotifierProvider<TabsProvider>(create: (_) => TabsProvider()),
          ChangeNotifierProvider<AjustesProvider>(
              create: (_) => AjustesProvider()),
          ChangeNotifierProvider<PrinterService>(
              create: (_) => PrinterService(navigatorKey)),
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
              //navigatorKey: navigatorKey,
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
                fontFamily: 'Poppins',
                primarySwatch: Colors.deepPurple,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurpleAccent,
                    primary: Colors.deepPurpleAccent,
                    secondary: Colors.black,
                    tertiary: Colors.red,
                    tertiaryContainer: Colors.red,
                    secondaryContainer: Colors.red),
                scaffoldBackgroundColor: Color.fromARGB(255, 253, 253, 253),
                appBarTheme: AppBarTheme(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0),
                listTileTheme: ListTileThemeData(
                  tileColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
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
              initialRoute: '/tabs',
              routes: {
                '/login': (context) => const LoginView(),
                '/tabs': (context) => const TabsView(),
                '/menu': (context) => const MenuView(),
                '/cart': (context) => const CartView(),
                '/pagos': (context) => const PagosView(),
                '/internet_status': (context) => const InternetStatusView(),
                '/informes': (context) => const InformesView(),
              }),
        ));
  }
}
