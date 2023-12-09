import 'package:flutter/material.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/empty_bag.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

// Orders Screen for Free users
class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  // Flag to check if there are no orders
  bool isEmptyOrders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title for the Orders Screen
        title: const TitlesTextWidget(
          label: 'Placed orders',
        ),
      ),
      body: isEmptyOrders
          ? // Display EmptyBagWidget if there are no orders
          EmptyBagWidget(
              imagePath: AssetsManager.order,
              title: "No orders have been placed yet",
              subtitle: "",
            )
          : // Display a list of OrdersWidgets
          ListView.separated(
              itemCount: 15, // Placeholder for the number of orders
              itemBuilder: (ctx, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrdersWidgetFree(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
    );
  }
}
