import 'package:flutter/material.dart';
import 'package:e_com_app_admin/screens/edit_upload_product_form.dart';
import 'package:e_com_app_admin/screens/inner_screens/orders/orders_screen.dart';
import 'package:e_com_app_admin/screens/search_screen.dart';

import '../services/assets_manager.dart';

// This class represents a model for dashboard buttons, each button having text, an image, and an onPressed function.
class DashboardButtonsModel {
  final String text; // Text displayed on the button.
  final String imagePath; // Image associated with the button.
  final Function
      onPressed; // Function to be executed when the button is pressed.

  // Constructor for creating a DashboardButtonsModel instance.
  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  // Static method to create a list of predefined dashboard buttons.
  static List<DashboardButtonsModel> dashboardBtnList(BuildContext context) => [
        // Button for adding a new product.
        DashboardButtonsModel(
          text: "Add a new product",
          imagePath: AssetsManager.cloud,
          onPressed: () {
            Navigator.pushNamed(
              context,
              EditOrUploadProductScreen.routeName,
            );
          },
        ),
        // Button for inspecting all products.
        DashboardButtonsModel(
          text: "Inspect all products",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
            Navigator.pushNamed(
              context,
              SearchScreen.routeName,
            );
          },
        ),
        // Button for viewing orders.
        DashboardButtonsModel(
          text: "View Orders",
          imagePath: AssetsManager.order,
          onPressed: () {
            Navigator.pushNamed(
              context,
              OrdersScreenFree.routeName,
            );
          },
        ),
      ];
}
