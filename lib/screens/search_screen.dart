import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../widgets/product_widget.dart';
import '../widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {
    // Access the ProductProvider using the Provider package
    final productProvider = Provider.of<ProductProvider>(context);

    // Retrieve the category passed to the screen
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;

    // Retrieve the list of products based on the passed category
    final List<ProductModel> productList = passedCategory == null
        ? productProvider.getProducts
        : productProvider.findByCategory(ctgName: passedCategory);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitlesTextWidget(label: passedCategory ?? "Search"),
        ),
        body: StreamBuilder<List<ProductModel>>(
          // StreamBuilder to listen for changes in the product list
          stream: productProvider.fetchProductsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If data is still loading, show a loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If an error occurs, display an error message
              return Center(
                child: TitlesTextWidget(
                  label: snapshot.error.toString(),
                ),
              );
            } else if (snapshot.data == null) {
              // If no products have been added, display a message
              return const Center(
                child: TitlesTextWidget(
                  label: "No product has been added",
                ),
              );
            }

            // Build the main UI
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  // Search bar with clear button
                  TextField(
                    controller: searchTextController,
                    decoration: InputDecoration(
                      hintText: "Search",
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // Clear the search text when the clear button is pressed
                          searchTextController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      // Update the search results as the user types
                      setState(() {
                        productListSearch = productProvider.searchQuery(
                          searchText: searchTextController.text,
                          passedList: productList,
                        );
                      });
                    },
                    onSubmitted: (value) {
                      // Update the search results when the user submits the search
                      setState(() {
                        productListSearch = productProvider.searchQuery(
                          searchText: searchTextController.text,
                          passedList: productList,
                        );
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  // Display a message if no results are found
                  if (searchTextController.text.isNotEmpty &&
                      productListSearch.isEmpty) ...[
                    const Center(
                      child: TitlesTextWidget(
                        label: "No results found",
                        fontSize: 40,
                      ),
                    )
                  ],
                  // Display the list of products in a DynamicHeightGridView
                  Expanded(
                    child: DynamicHeightGridView(
                      itemCount: searchTextController.text.isNotEmpty
                          ? productListSearch.length
                          : productList.length,
                      builder: ((context, index) {
                        return ProductWidget(
                          productId: searchTextController.text.isNotEmpty
                              ? productListSearch[index].productId
                              : productList[index].productId,
                        );
                      }),
                      crossAxisCount: 2,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
