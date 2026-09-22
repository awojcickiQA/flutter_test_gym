import 'package:flutter/material.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/testable_widget.dart';
import '../../../dev_tools/test_inspector_overlay.dart';
import '../controllers/shop_state.dart';
import '../models/product.dart';

class ShopCatalogScreen extends StatefulWidget {
  const ShopCatalogScreen({super.key});

  @override
  State<ShopCatalogScreen> createState() => _ShopCatalogScreenState();
}

class _ShopCatalogScreenState extends State<ShopCatalogScreen> {
  final _state = ShopState.instance;
  final _searchController = TextEditingController();

  String _selectedCategory = 'Wszystkie';
  String _selectedSort = 'Domyślnie';

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  List<Product> get _filteredProducts {
    List<Product> list = List.from(_state.catalog);

    // Kategoria
    if (_selectedCategory != 'Wszystkie') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }

    // Wyszukiwanie
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) => p.title.toLowerCase().contains(q) || p.description.toLowerCase().contains(q)).toList();
    }

    // Sortowanie
    if (_selectedSort == 'Cena: rosnąco') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Cena: malejąco') {
      list.sort((a, b) => b.price.compareTo(a.price));
    }

    return list;
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'phone_android':
        return Icons.phone_android;
      case 'keyboard':
        return Icons.keyboard;
      case 'mouse':
        return Icons.mouse;
      case 'desktop_windows':
        return Icons.desktop_windows;
      case 'menu_book':
        return Icons.menu_book;
      case 'coffee':
        return Icons.coffee;
      default:
        return Icons.devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.shopCatalogSearchInput,
      AppKeys.shopCatalogSortDropdown,
      AppKeys.shopCatalogCartBtn,
      AppKeys.shopCatalogCartBadge,
    ];

    final categories = ['Wszystkie', 'Elektronika', 'Akcesoria', 'Książki', 'Gadżety'];

    return TestInspectorOverlay(
      currentRoute: '/shop/catalog',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.shopCatalogScreen),
        appBar: AppBar(
          title: const Text('Katalog Produktów'),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                TestableWidget(
                  keyId: AppKeys.shopCatalogCartBtn,
                  semanticLabel: 'Koszyk sklepowy',
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.shopCart);
                    },
                  ),
                ),
                if (_state.totalCartQuantity > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: TestableWidget(
                      keyId: AppKeys.shopCatalogCartBadge,
                      semanticLabel: 'Liczba w koszyku: ${_state.totalCartQuantity}',
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '${_state.totalCartQuantity}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // Pasek filtrów i wyszukiwania
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TestableWidget(
                      keyId: AppKeys.shopCatalogSearchInput,
                      semanticLabel: 'Szukaj w sklepie',
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Szukaj w sklepie...',
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TestableWidget(
                    keyId: AppKeys.shopCatalogSortDropdown,
                    semanticLabel: 'Sortowanie',
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      items: const [
                        DropdownMenuItem(value: 'Domyślnie', child: Text('Domyślnie')),
                        DropdownMenuItem(value: 'Cena: rosnąco', child: Text('Cena: ↑')),
                        DropdownMenuItem(value: 'Cena: malejąco', child: Text('Cena: ↓')),
                      ],
                      onChanged: (val) => setState(() => _selectedSort = val!),
                    ),
                  ),
                ],
              ),
            ),

            // Chipy kategorii
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: FilterChip(
                      key: Key('${AppKeys.shopCatalogFilterChipPrefix}${cat.toLowerCase()}'),
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(),

            // Siatka produktów
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text('Brak produktów spełniających kryteria'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Card(
                          key: Key(AppKeys.shopProductCard(product.id)),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Icon(_getIconData(product.iconName), size: 48, color: Colors.indigo),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  product.category.toUpperCase(),
                                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product.price.toStringAsFixed(2)} PLN',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: TestableWidget(
                                    keyId: AppKeys.shopProductAddBtn(product.id),
                                    semanticLabel: 'Dodaj ${product.title} do koszyka',
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                      ),
                                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                                      label: const Text('Dodaj', style: TextStyle(fontSize: 12)),
                                      onPressed: () {
                                        _state.addToCart(product);
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Dodano "${product.title}" do koszyka'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
