import 'package:e_com_app_admin/firebase_options.dart';
import 'package:e_com_app_admin/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/edit_upload_product_form.dart';
import 'screens/inner_screens/orders/orders_screen.dart';
import 'screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for managing the app's theme
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        // Provider for managing product data
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (
          context,
          themeProvider,
          child,
        ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop Smart ADMIN AR',
            // Set the app's theme based on the user's preference
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const DashboardScreen(),
            // Define named routes for navigation
            routes: {
              OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              EditOrUploadProductScreen.routeName: (context) =>
                  const EditOrUploadProductScreen(),
            },
          );
        },
      ),
    );
  }
}
