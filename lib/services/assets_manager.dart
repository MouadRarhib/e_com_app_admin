// assets_manager.dart

// This class manages the paths for various asset images used in the application.

class AssetsManager {
  // Path for general images
  static String imagesPath = "assets/images";

  // Path for category images
  static String categoriesImagesPath = "assets/images/categories";

  // Path for dashboard images
  static String dashboardImagesPath = "assets/images/dashboard";

  // General images
  static String warning = "$imagesPath/warning.png";
  static String error = "$imagesPath/error.png";
  static String emptySearch = "$imagesPath/empty_search.png";
  static String shoppingCart = "$imagesPath/shopping_cart.png";

  // Category images
  static String mobiles = "$categoriesImagesPath/mobiles.png";
  static String fashion = "$categoriesImagesPath/fashion.png";
  static String watch = "$categoriesImagesPath/watch.png";
  static String book = "$categoriesImagesPath/book_img.png";
  static String electronics = "$categoriesImagesPath/electronics.png";
  static String cosmetics = "$categoriesImagesPath/cosmetics.png";
  static String shoes = "$categoriesImagesPath/shoes.png";
  static String pc = "$categoriesImagesPath/pc.png";

  // Dashboard images
  static String order = "$dashboardImagesPath/order.png";
  static String cloud = "$dashboardImagesPath/cloud.png";
}
