import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_com_app_admin/consts/app_constants.dart';
import 'package:e_com_app_admin/models/product_model.dart';
import 'package:e_com_app_admin/services/my_app_method.dart';
import 'package:e_com_app_admin/widgets/subtitle_text.dart';
import 'package:uuid/uuid.dart';

import '../consts/my_validators.dart';
import '../widgets/title_text.dart';
import 'loading_manager.dart';

// EditOrUploadProductScreen class, which extends StatefulWidget
class EditOrUploadProductScreen extends StatefulWidget {
  // Static constant for the route name
  static const routeName = '/EditOrUploadProductScreen';

  // Constructor that takes an optional productModel parameter
  const EditOrUploadProductScreen({
    super.key,
    this.productModel,
  });

  // An optional parameter to receive a ProductModel instance
  final ProductModel? productModel;

  // Override createState method to create the state for this widget
  @override
  State<EditOrUploadProductScreen> createState() =>
      _EditOrUploadProductScreenState();
}

// State class for EditOrUploadProductScreen
class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  // GlobalKey for the Form widget
  final _formKey = GlobalKey<FormState>();

  // XFile to store the picked image
  XFile? _pickedImage;

  // Flag to track whether the screen is in editing mode
  bool isEditing = false;

  // String to store the network image URL for editing
  String? productNetworkImage;

  // TextEditingController for various text input fields
  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;

  // String to store the selected category
  String? _categoryValue;

  // Flag to track the loading state
  bool _isLoading = false;

  // String to store the product image URL
  String? productImageUrl;

  // Override the initState method to perform initialization
  @override
  void initState() {
    // Check if a productModel is provided (editing mode)
    if (widget.productModel != null) {
      // Set the editing flag to true
      isEditing = true;
      // Set the productNetworkImage from the productModel
      productNetworkImage = widget.productModel!.productImage;
      // Set the categoryValue from the productModel
      _categoryValue = widget.productModel!.productCategory;
    }

    // Initialize the TextEditingController instances
    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController =
        TextEditingController(text: widget.productModel?.productPrice);
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quantityController =
        TextEditingController(text: widget.productModel?.productQuantity);

    // Call the initState of the parent class
    super.initState();
  }

  // Override the dispose method to release resources
  @override
  void dispose() {
    // Dispose of the TextEditingController instances
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    // Call the dispose of the parent class
    super.dispose();
  }

  // Method to clear the form fields
  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    removePickedImage();
  }

  // Method to remove the picked image
  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  // Method to handle the product upload process
  Future<void> _uploadProduct() async {
    // Validate the form
    final isValid = _formKey.currentState!.validate();
    // Close the keyboard
    FocusScope.of(context).unfocus();

    // Check if an image is picked
    if (_pickedImage == null) {
      // Show a dialog if no image is picked
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Make sure to pick up an image",
        fct: () {},
      );
      return;
    }

    // Check if a category is selected
    if (_categoryValue == null) {
      // Show a dialog if no category is selected
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Category is empty",
        fct: () {},
      );
      return;
    }

    // Check if the form is valid
    if (isValid) {
      // Save the form data
      _formKey.currentState!.save();
      try {
        // Set the loading state to true
        setState(() {
          _isLoading = true;
        });

        // Check if an image is picked
        if (_pickedImage != null) {
          // Create a reference to the Firebase Storage for the image
          final ref = FirebaseStorage.instance
              .ref()
              .child("productsImages")
              .child('${_titleController.text.trim()}.jpg');

          // Upload the image to Firebase Storage
          await ref.putFile(File(_pickedImage!.path));
          // Get the download URL of the uploaded image
          productImageUrl = await ref.getDownloadURL();
        }

        // Generate a unique product ID using Uuid
        final productID = const Uuid().v4();

        // Add the product data to the "products" collection in Firestore
        await FirebaseFirestore.instance
            .collection("products")
            .doc(productID)
            .set({
          'productId': productID,
          'productTitle': _titleController.text,
          'productPrice': _priceController.text,
          'productImage': productImageUrl,
          'productCategory': _categoryValue,
          'productDescription': _descriptionController.text,
          'productQuantity': _quantityController.text,
          'createdAt': Timestamp.now(),
        });

        // Show a success toast message
        Fluttertoast.showToast(
          msg: "Product has been added",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );

        // Check if the widget is still mounted before showing a dialog
        if (!mounted) return;
        // Show a dialog to clear the form
        await MyAppMethods.showErrorORWarningDialog(
          isError: false,
          context: context,
          subtitle: "Clear form?",
          fct: () {
            clearForm();
          },
        );
      } on FirebaseException catch (error) {
        // Show an error dialog for Firebase exceptions
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occurred ${error.message}",
          fct: () {},
        );
      } catch (error) {
        // Show an error dialog for other exceptions
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occurred $error",
          fct: () {},
        );
      } finally {
        // Set the loading state to false
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Method to handle the product editing process
  Future<void> _editProduct() async {
    // Validate the form
    final isValid = _formKey.currentState!.validate();
    // Close the keyboard
    FocusScope.of(context).unfocus();

    // Check if no image is picked and there's no network image for editing
    if (_pickedImage == null && productNetworkImage == null) {
      // Show a dialog if no image is picked
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Please pick up an image",
        fct: () {},
      );
      return;
    }

    // Check if a category is selected
    if (_categoryValue == null) {
      // Show a dialog if no category is selected
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Category is empty",
        fct: () {},
      );
      return;
    }

    // Check if the form is valid
    if (isValid) {
      // Save the form data
      _formKey.currentState!.save();
      try {
        // Set the loading state to true
        setState(() {
          _isLoading = true;
        });

        // Check if an image is picked
        if (_pickedImage != null) {
          // Create a reference to the Firebase Storage for the image
          final ref = FirebaseStorage.instance
              .ref()
              .child("productsImages")
              .child('${_titleController.text.trim()}.jpg');

          // Upload the image to Firebase Storage
          await ref.putFile(File(_pickedImage!.path));
          // Get the download URL of the uploaded image
          productImageUrl = await ref.getDownloadURL();
        }

        // Update the product data in the "products" collection in Firestore
        await FirebaseFirestore.instance
            .collection("products")
            .doc(widget.productModel!.productId)
            .update({
          'productId': widget.productModel!.productId,
          'productTitle': _titleController.text,
          'productPrice': _priceController.text,
          'productImage': productImageUrl ?? productNetworkImage,
          'productCategory': _categoryValue,
          'productDescription': _descriptionController.text,
          'productQuantity': _quantityController.text,
          'createdAt': widget.productModel!.createdAt,
        });

        // Show a success toast message
        Fluttertoast.showToast(
          msg: "Product has been edited",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );

        // Check if the widget is still mounted before showing a dialog
        if (!mounted) return;
        // Show a dialog to clear the form
        await MyAppMethods.showErrorORWarningDialog(
          isError: false,
          context: context,
          subtitle: "Clear form?",
          fct: () {
            clearForm();
          },
        );
      } on FirebaseException catch (error) {
        // Show an error dialog for Firebase exceptions
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occurred ${error.message}",
          fct: () {},
        );
      } catch (error) {
        // Show an error dialog for other exceptions
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occurred $error",
          fct: () {},
        );
      } finally {
        // Set the loading state to false
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Method to pick an image from the local device
  Future<void> localImagePicker() async {
    // Create an instance of ImagePicker
    final ImagePicker picker = ImagePicker();
    // Show an image picker dialog with camera, gallery, and remove options
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        // Pick an image from the camera
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        // Set the network image to null
        setState(() {
          productNetworkImage = null;
        });
      },
      galleryFCT: () async {
        // Pick an image from the gallery
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        // Set the network image to null
        setState(() {
          productNetworkImage = null;
        });
      },
      removeFCT: () {
        // Remove the picked image
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      "Clear",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      // backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.upload),
                    label: Text(
                      isEditing ? "Edit Product" : "Upload Product",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (isEditing) {
                        _editProduct();
                      } else {
                        _uploadProduct();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const TitlesTextWidget(
              label: "Upload a new product",
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  if (isEditing && productNetworkImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productNetworkImage!,
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ] else if (_pickedImage == null) ...[
                    SizedBox(
                      width: size.width * 0.4 + 10,
                      height: size.width * 0.4,
                      child: DottedBorder(
                          color: Colors.blue,
                          radius: const Radius.circular(12),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: Colors.blue,
                                ),
                                TextButton(
                                  onPressed: () {
                                    localImagePicker();
                                  },
                                  child: const Text("Pick Product image"),
                                ),
                              ],
                            ),
                          )),
                    )
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(
                          _pickedImage!.path,
                        ),
                        // width: size.width * 0.7,
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                  if (_pickedImage != null || productNetworkImage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            localImagePicker();
                          },
                          child: const Text("Pick another image"),
                        ),
                        TextButton(
                          onPressed: () {
                            removePickedImage();
                          },
                          child: const Text(
                            "Remove image",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  ],
                  const SizedBox(
                    height: 25,
                  ),
                  DropdownButton<String>(
                    hint: Text(_categoryValue ?? "Select Category"),
                    value: _categoryValue,
                    items: AppConstants.categoriesDropDownList,
                    onChanged: (String? value) {
                      setState(() {
                        _categoryValue = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey('Title'),
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              hintText: 'Product Title',
                            ),
                            validator: (value) {
                              return MyValidators.uploadProdTexts(
                                value: value,
                                toBeReturnedString:
                                    "Please enter a valid title",
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _priceController,
                                  key: const ValueKey('Price \$'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: const InputDecoration(
                                      hintText: 'Price',
                                      prefix: SubtitleTextWidget(
                                        label: "\$ ",
                                        color: Colors.blue,
                                        fontSize: 16,
                                      )),
                                  validator: (value) {
                                    return MyValidators.uploadProdTexts(
                                      value: value,
                                      toBeReturnedString: "Price is missing",
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  key: const ValueKey('Quantity'),
                                  decoration: const InputDecoration(
                                    hintText: 'Qty',
                                  ),
                                  validator: (value) {
                                    return MyValidators.uploadProdTexts(
                                      value: value,
                                      toBeReturnedString: "Quantity is missed",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('Description'),
                            controller: _descriptionController,
                            minLines: 5,
                            maxLines: 8,
                            maxLength: 1000,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Product description',
                            ),
                            validator: (value) {
                              return MyValidators.uploadProdTexts(
                                value: value,
                                toBeReturnedString: "Description is missed",
                              );
                            },
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
