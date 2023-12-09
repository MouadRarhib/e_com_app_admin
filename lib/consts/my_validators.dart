// This class defines custom validators used in the app.
class MyValidators {
  // Validator for checking if a text field is empty during product upload.
  // Returns the specified error message if the value is empty, otherwise returns null.
  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}
