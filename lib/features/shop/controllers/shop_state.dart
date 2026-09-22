import 'package:flutter/material.dart';
import '../models/product.dart';

class ShopState extends ChangeNotifier {
  static final ShopState instance = ShopState._internal();
  ShopState._internal();

  final List<Product> _catalog = const [
    Product(
      id: 'prod_1',
      title: 'Smartfon QA Pro',
      category: 'Elektronika',
      price: 1999.00,
      description: 'Dedykowany smartfon z wbudowanym debugerem i testami.',
      iconName: 'phone_android',
    ),
    Product(
      id: 'prod_2',
      title: 'Klawiatura Mechaniczna SDET',
      category: 'Akcesoria',
      price: 349.99,
      description: 'Cicha klawiatura z podświetleniem RGB dla inżynierów testów.',
      iconName: 'keyboard',
    ),
    Product(
      id: 'prod_3',
      title: 'Myszka Bezprzewodowa Ergonomiczna',
      category: 'Akcesoria',
      price: 159.00,
      description: 'Zapewnia precyzję i wygodę podczas wielogodzinnych sesji testowych.',
      iconName: 'mouse',
    ),
    Product(
      id: 'prod_4',
      title: 'Monitor 4K UltraWide 34"',
      category: 'Elektronika',
      price: 2499.00,
      description: 'Idealny do podglądu wielu emulatorów i logów jednocześnie.',
      iconName: 'desktop_windows',
    ),
    Product(
      id: 'prod_5',
      title: 'Książka: Wzorce Automatyzacji Testów',
      category: 'Książki',
      price: 79.50,
      description: 'Bestsellerowy podręcznik Page Object Model i Screenplay.',
      iconName: 'menu_book',
    ),
    Product(
      id: 'prod_6',
      title: 'Kubek Termiczny "Automated QA"',
      category: 'Gadżety',
      price: 49.00,
      description: 'Ciepła kawa przez 8 godzin podczas nocnych regresji.',
      iconName: 'coffee',
    ),
  ];

  final Map<String, CartItem> _cart = {};
  String? _appliedCoupon;
  double _discountRate = 0.0;
  String? _lastOrderId;

  List<Product> get catalog => _catalog;
  Map<String, CartItem> get cart => _cart;
  int get totalCartQuantity => _cart.values.fold(0, (sum, item) => sum + item.quantity);
  String? get appliedCoupon => _appliedCoupon;
  String? get lastOrderId => _lastOrderId;

  double get subtotal => _cart.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get discountAmount => subtotal * _discountRate;
  double get finalTotal => (subtotal - discountAmount) > 0 ? (subtotal - discountAmount) : 0.0;

  void addToCart(Product product) {
    if (_cart.containsKey(product.id)) {
      _cart[product.id]!.quantity += 1;
    } else {
      _cart[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (_cart.containsKey(productId)) {
      if (_cart[productId]!.quantity > 1) {
        _cart[productId]!.quantity -= 1;
      } else {
        _cart.remove(productId);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  bool applyCoupon(String code) {
    if (code.trim().toUpperCase() == 'DISCOUNT10') {
      _appliedCoupon = 'DISCOUNT10 (10% taniej)';
      _discountRate = 0.10;
      notifyListeners();
      return true;
    }
    return false;
  }

  String checkout() {
    final newId = 'ORD-${DateTime.now().millisecondsSinceEpoch % 100000}';
    _lastOrderId = newId;
    _cart.clear();
    _appliedCoupon = null;
    _discountRate = 0.0;
    notifyListeners();
    return newId;
  }

  void reset() {
    _cart.clear();
    _appliedCoupon = null;
    _discountRate = 0.0;
    _lastOrderId = null;
    notifyListeners();
  }
}
