import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// This class represents a model for a product with ChangeNotifier for state management.
class ProductModel with ChangeNotifier {
  final String productId; // Unique identifier for the product.
  final String productTitle; // Title of the product.
  final String productPrice; // Price of the product.
  final String productCategory; // Category of the product.
  final String productDescription; // Description of the product.
  final String productImage; // Image URL of the product.
  final String productQuantity; // Quantity of the product.
  Timestamp? createdAt; // Timestamp indicating when the product was created.

  // Constructor for creating a ProductModel instance.
  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    this.createdAt,
  });

  // Factory method for creating a ProductModel instance from Firestore document data.
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: data['productId'],
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productCategory: data['productCategory'],
      productDescription: data['productDescription'],
      productImage: data['productImage'],
      productQuantity: data['productQuantity'],
      createdAt: data['createdAt'],
    );
  }
}
