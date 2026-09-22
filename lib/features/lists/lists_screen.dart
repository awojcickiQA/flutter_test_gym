import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_keys.dart';
import '../../core/widgets/testable_widget.dart';
import '../../dev_tools/test_inspector_overlay.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  List<String> _allItems = [];
  List<String> _filteredItems = [];
  bool _isLoadingMore = false;
  int _itemLimit = 50; // Początkowo 50 elementów, można dociągać do 500

  @override
  void initState() {
    super.initState();
    _generateItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateItems() {
    _allItems = List.generate(
      _itemLimit,
      (index) => 'Rekord danych #${index + 1} - Identyfikator QA-${(index + 1) * 107}',
    );
    _filterItems(_searchController.text);
  }

  void _filterItems(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        _filteredItems = _allItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _itemLimit < 500) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _itemLimit += 30;
      _generateItems();
      _isLoadingMore = false;
    });
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _itemLimit = 50;
      _generateItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableKeys = [
      AppKeys.listsSearchInput,
      AppKeys.listsSearchClearBtn,
      AppKeys.listsItemCountText,
      AppKeys.listsInfiniteListView,
      AppKeys.listsRefreshIndicator,
      AppKeys.listsEmptyState,
      AppKeys.listsLoadingMoreSpinner,
    ];

    return TestInspectorOverlay(
      currentRoute: '/lists',
      availableKeys: availableKeys,
      child: Scaffold(
        key: const Key(AppKeys.listsScreen),
        appBar: AppBar(
          title: const Text('Listy & Wirtualizacja'),
        ),
        body: Column(
          children: [
            // Pasek wyszukiwania i statystyk
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.indigo.shade50,
              child: Column(
                children: [
                  TestableWidget(
                    keyId: AppKeys.listsSearchInput,
                    semanticLabel: 'Szukaj rekordu',
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: _filterItems,
                      decoration: InputDecoration(
                        hintText: 'Szukaj rekordu (np. "150", "QA-")...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? TestableWidget(
                                keyId: AppKeys.listsSearchClearBtn,
                                semanticLabel: 'Wyczyść wyszukiwanie',
                                child: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterItems('');
                                  },
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TestableWidget(
                        keyId: AppKeys.listsItemCountText,
                        semanticLabel: 'Widocznych elementów: ${_filteredItems.length}',
                        child: Text(
                          'Widocznych elementów: ${_filteredItems.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const Text(
                        'Pociągnij w dół aby odświeżyć',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Główna lista z leniwym ładowaniem
            Expanded(
              child: _filteredItems.isEmpty
                  ? TestableWidget(
                      keyId: AppKeys.listsEmptyState,
                      semanticLabel: 'Nie znaleziono pasujących rekordów.',
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('Nie znaleziono pasujących rekordów.', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      key: const Key(AppKeys.listsRefreshIndicator),
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                        key: const Key(AppKeys.listsInfiniteListView),
                        controller: _scrollController,
                        itemCount: _filteredItems.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _filteredItems.length) {
                            return const Center(
                              key: Key(AppKeys.listsLoadingMoreSpinner),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final item = _filteredItems[index];
                          final itemId = index + 1;

                          return TestableWidget(
                            keyId: AppKeys.listsItemTile(itemId),
                            semanticLabel: item,
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.indigo.shade100,
                                  child: Text('$itemId', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                                title: Text(
                                  item,
                                  key: Key(AppKeys.listsItemTitle(itemId)),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text('Status: Aktywny • Indeks: $index'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.info_outline, size: 20),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Szczegóły elementu: $item')),
                                    );
                                  },
                                ),
                              ),
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
  }
}
