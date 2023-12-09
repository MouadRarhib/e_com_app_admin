// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_com_app_admin/widgets/title_text.dart';

import '../models/dashboard_btn_model.dart';
import '../providers/theme_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/dashboard_btn.dart';

// Defining the DashboardScreen widget
class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

// State class for DashboardScreen
class DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Accessing the theme provider using Provider.of
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // App bar with title, leading icon, and dark mode switch
      appBar: AppBar(
        title: const TitlesTextWidget(label: "Dashboard Screen"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        actions: [
          IconButton(
            // Switch between dark and light mode
            onPressed: () {
              themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      // Body containing a GridView of dashboard buttons
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: DashboardButtonsWidget(
              // Set button properties based on DashboardButtonsModel
              title:
                  DashboardButtonsModel.dashboardBtnList(context)[index].text,
              imagePath: DashboardButtonsModel.dashboardBtnList(context)[index]
                  .imagePath,
              onPressed: () {
                DashboardButtonsModel.dashboardBtnList(context)[index]
                    .onPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}
