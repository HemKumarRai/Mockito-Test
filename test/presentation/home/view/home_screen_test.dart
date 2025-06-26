import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_test/data/models/product.dart';
import 'package:test_test/domain/usecases/add_product_usecase.dart' show AddProductUseCase;
import 'package:test_test/domain/usecases/get_products_usecase.dart' show GetProductsUseCase;
import 'package:test_test/presentation/add_product/viewmodel/add_product_viewmodel.dart';
import 'package:test_test/presentation/home/view/all_products_view.dart';
import 'package:test_test/presentation/home/view/favorite_products_view.dart';
import 'package:test_test/presentation/home/view/home_screen.dart';
import 'package:test_test/presentation/home/viewmodel/home_viewmodel.dart';

import 'home_screen_test.mocks.dart'; // Generated mock file

// Generate mocks for necessary use cases
@GenerateMocks([GetProductsUseCase, AddProductUseCase])
void main() {
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockAddProductUseCase mockAddProductUseCase;

  // Helper function to pump the widget for testing
  Widget createWidgetUnderTest() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockAddProductUseCase = MockAddProductUseCase();

    // Mock GetProductsUseCase to return an empty list initially for AllProductsView
    when(mockGetProductsUseCase.call()).thenAnswer((_) async => []);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(mockGetProductsUseCase),
        ),
        ChangeNotifierProvider<AddProductViewModel>(
          create: (_) => AddProductViewModel(mockAddProductUseCase),
        ),
      ],
      child: MaterialApp(
        home: const HomeScreen(),
        routes: {
          '/add_product': (context) => Scaffold(
            appBar: AppBar(title: const Text('Add Product Screen')),
            body: const Text('Add Product Screen Content'),
          ),
        },
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen displays app bar title and bottom navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for initial data fetch (empty products)

      // Verify app bar title
      expect(find.text('Everest Shop'), findsOneWidget);

      // Verify bottom navigation items
      expect(find.byIcon(Icons.grid_on), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('All Products'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('HomeScreen shows AllProductsView by default', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for data fetching

      // Verify that AllProductsView content is visible
      expect(find.byType(AllProductsView), findsOneWidget);
      expect(find.text('No products found.'), findsOneWidget); // Assuming mock returns empty
      expect(find.byType(FavoriteProductsView), findsNothing);
    });

    testWidgets('Tapping Favorites tab switches to FavoriteProductsView', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for initial data fetch

      // Tap the Favorites tab
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle(); // Wait for tab transition

      // Verify that FavoriteProductsView content is visible
      expect(find.byType(FavoriteProductsView), findsOneWidget);
      expect(find.text('No favorite products yet. Add some from the All Products tab!'), findsOneWidget);
      expect(find.byType(AllProductsView), findsNothing);
    });

    testWidgets('Tapping Add Product button navigates to AddProductScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for initial data fetch

      // Tap the add product button in the app bar
      await tester.tap(find.byKey(const ValueKey('addProductButton')));
      await tester.pumpAndSettle(); // Wait for navigation

      // Verify that AddProductScreen is displayed
      expect(find.text('Add Product Screen Content'), findsOneWidget);
      expect(find.text('Add Product Screen'), findsOneWidget); // AppBar title of the mocked screen
      expect(find.byType(HomeScreen), findsNothing); // HomeScreen should no longer be in the tree
    });

    testWidgets('Returning from AddProductScreen updates product list', (WidgetTester tester) async {
      final Product newProduct = Product(
        id: 'new1',
        name: 'Added Product',
        price: '123',
        productImage: 'https://example.com/new.jpg',
        quantity: '1',
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Load initial state (empty products)

      // Ensure that 'No products found.' is visible
      expect(find.text('No products found.'), findsOneWidget);

      // Simulate navigating to AddProductScreen and popping with a new product
      await tester.tap(find.byKey(const ValueKey('addProductButton')));
      await tester.pumpAndSettle(); // Navigate to AddProductScreen

      // Simulate returning from AddProductScreen with a new product
      Navigator.of(tester.element(find.text('Add Product Screen Content'))).pop(newProduct);
      await tester.pumpAndSettle(); // Wait for the pop and rebuild

      // Now, the AllProductsView should have the new product.
      // We need to re-mock the use case if we want to simulate refetch.
      // For this test, we're checking if addNewProduct was called on the ViewModel.
      final homeViewModel = Provider.of<HomeViewModel>(tester.element(find.byType(HomeScreen)), listen: false);

      // Since we simulate returning with a product, the HomeViewModel's addNewProduct should be called.
      // The current implementation of `addNewProduct` adds to the existing list.
      expect(homeViewModel.allProducts, contains(newProduct));
      expect(find.text('Added Product'), findsOneWidget); // Verify new product is displayed
      expect(find.text('No products found.'), findsNothing); // Old message should be gone
    });
  });
}
