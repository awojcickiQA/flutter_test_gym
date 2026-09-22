class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final String description;
  final String iconName;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.iconName,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}
