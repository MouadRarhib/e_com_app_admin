// product_provider.dart

// Importing necessary Flutter and Firestore packages.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Importing the product model for type references.
import '../models/product_model.dart';

// A provider class for managing product-related state and data.
class ProductProvider with ChangeNotifier {
  // Private list to store product data.
  final List<ProductModel> _products = [];

  // Getter to access the list of products.
  List<ProductModel> get getProducts {
    return _products;
  }

  // Find a product by its ID.
  ProductModel? findByProdId(String productId) {
    // If the product with the specified ID is not found, return null.
    if (_products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    // Return the first product found with the specified ID.
    return _products.firstWhere((element) => element.productId == productId);
  }

  // Filter products based on a given category name.
  List<ProductModel> findByCategory({required String ctgName}) {
    // Create a list of products that match the specified category.
    List<ProductModel> ctgList = _products
        .where((element) => element.productCategory
            .toLowerCase()
            .contains(ctgName.toLowerCase()))
        .toList();
    return ctgList;
  }

  // Filter products based on a search text within a given list.
  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    // Create a list of products that match the search text.
    List<ProductModel> searchList = passedList
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }

  // Firestore collection reference for products.
  final productDB = FirebaseFirestore.instance.collection("products");

  // Fetch products from Firestore.
  Future<List<ProductModel>> fetchProducts() async {
    try {
      // Fetch products from Firestore and update the local list.
      await productDB.get().then((productsSnapshot) {
        _products.clear();
        for (var element in productsSnapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      // Notify listeners of the state change.
      notifyListeners();
      // Return the updated list of products.
      return _products;
    } catch (error) {
      // Rethrow any errors that occur during the process.
      rethrow;
    }
  }

  // Stream of product data from Firestore.
  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      // Return a stream of products from Firestore.
      return productDB.snapshots().map((snapshot) {
        _products.clear();
        // Populate the local list with data from the snapshot.
        for (var element in snapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
        // Return the updated list through the stream.
        return _products;
      });
    } catch (e) {
      // Rethrow any errors that occur during the process.
      rethrow;
    }
  }
}
