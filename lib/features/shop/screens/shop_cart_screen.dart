import 'package:flutter/material.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/testable_widget.dart';
import '../../../dev_tools/test_inspector_overlay.dart';
import '../controllers/shop_state.dart';

class ShopCartScreen extends StatefulWidget {
  const ShopCartScreen({super.key});

  @override
  State<ShopCartScreen> createState() => _ShopCartScreenState();
}

class _ShopCartScreenState extends State<ShopCartScreen> {
  final _state = ShopState.instance;
  final _couponController = TextEditingController();
  String? _couponMessage;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChange);
    _couponController.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (_state.applyCoupon(code)) {
      setState(() {
        _couponMessage = 'Kupon "DISCOUNT10" został pomyślnie naliczony!';
      });
    } else {
      setState(() {
        _couponMessage = 'Błąd: Niepoprawny kod kuponu (użyj DISCOUNT10)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.shopCartItemsList,
      AppKeys.shopCartCouponInput,
      AppKeys.shopCartCouponApplyBtn,
      AppKeys.shopCartSubtotalText,
      AppKeys.shopCartDiscountText,
      AppKeys.shopCartTotalText,
      AppKeys.shopCartCheckoutBtn,
    ];

    final cartItems = _state.cart.values.toList();

    return TestInspectorOverlay(
      currentRoute: '/shop/cart',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.shopCartScreen),
        appBar: AppBar(title: const Text('Twój Koszyk')),
        body: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.remove_shopping_cart, size: 72, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Twój koszyk jest pusty!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Wróć do katalogu'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Lista produktów w koszyku
                  Expanded(
                    child: ListView.builder(
                      key: const Key(AppKeys.shopCartItemsList),
                      padding: const EdgeInsets.all(12),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          key: Key(AppKeys.shopCartItem(item.product.id)),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      Text(
                                        'Cena jedn.: ${item.product.price.toStringAsFixed(2)} PLN',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      Text(
                                        'Razem: ${item.totalPrice.toStringAsFixed(2)} PLN',
                                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    TestableWidget(
                                      keyId: AppKeys.shopCartQtyDecrease(item.product.id),
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () => _state.decreaseQuantity(item.product.id),
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    TestableWidget(
                                      keyId: AppKeys.shopCartQtyIncrease(item.product.id),
                                      child: IconButton(
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () => _state.addToCart(item.product),
                                      ),
                                    ),
                                    TestableWidget(
                                      keyId: AppKeys.shopCartItemDelete(item.product.id),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => _state.removeFromCart(item.product.id),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Pole kodu rabatowego i podsumowanie
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TestableWidget(
                                keyId: AppKeys.shopCartCouponInput,
                                semanticLabel: 'Wpisz kod kuponu',
                                child: TextField(
                                  controller: _couponController,
                                  decoration: const InputDecoration(
                                    hintText: 'Wpisz kod: DISCOUNT10',
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TestableWidget(
                              keyId: AppKeys.shopCartCouponApplyBtn,
                              semanticLabel: 'Zastosuj kupon',
                              child: ElevatedButton(
                                onPressed: _applyCoupon,
                                child: const Text('Zastosuj'),
                              ),
                            ),
                          ],
                        ),
                        if (_couponMessage != null) ...[
                          const SizedBox(height: 6),
                          TestableWidget(
                            keyId: AppKeys.shopCartCouponBadge,
                            semanticLabel: _couponMessage!,
                            child: Text(
                              _couponMessage!,
                              style: TextStyle(
                                fontSize: 12,
                                color: _couponMessage!.contains('Błąd') ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Suma częściowa:'),
                            TestableWidget(
                              keyId: AppKeys.shopCartSubtotalText,
                              semanticLabel: '${_state.subtotal.toStringAsFixed(2)} PLN',
                              child: Text(
                                '${_state.subtotal.toStringAsFixed(2)} PLN',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        if (_state.discountAmount > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Rabat (10%):', style: TextStyle(color: Colors.green)),
                              TestableWidget(
                                keyId: AppKeys.shopCartDiscountText,
                                semanticLabel: '-${_state.discountAmount.toStringAsFixed(2)} PLN',
                                child: Text(
                                  '-${_state.discountAmount.toStringAsFixed(2)} PLN',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Do zapłaty:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            TestableWidget(
                              keyId: AppKeys.shopCartTotalText,
                              semanticLabel: '${_state.finalTotal.toStringAsFixed(2)} PLN',
                              child: Text(
                                '${_state.finalTotal.toStringAsFixed(2)} PLN',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TestableWidget(
                          keyId: AppKeys.shopCartCheckoutBtn,
                          semanticLabel: 'Przejdź do kasy',
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRoutes.shopCheckout);
                            },
                            child: const Text('Przejdź do kasy (Checkout)', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
