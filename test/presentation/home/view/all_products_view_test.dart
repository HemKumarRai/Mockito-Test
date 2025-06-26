import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:test_test/data/models/product.dart' show Product;
import 'package:test_test/data/repositories/product_repository.dart';
import 'package:test_test/data/services/api_service.dart';
import 'package:test_test/domain/usecases/get_products_usecase.dart';
import 'package:test_test/presentation/home/view/all_products_view.dart';
import 'package:test_test/presentation/home/viewmodel/home_viewmodel.dart';
import 'package:test_test/presentation/home/widget/product_grid_item.dart'
    show ProductGridItem;
import 'package:test_test/presentation/shared/widgets/loading_indicator.dart'
    show LoadingIndicator;
import 'all_products_view_test.mocks.dart';

@GenerateMocks([GetProductsUseCase])
void main() {
  late HomeViewModel homeViewModel;
  late MockGetProductsUseCase mockGetProductsUseCase;
  final List<Product> dummyProducts = [
    Product(
      id: '1',
      name: 'Product A',
      price: '10.00',
      productImage: 'https://via.placeholder.com/150',
      quantity: '1',
    ),
    Product(
      id: '2',
      name: 'Product B',
      price: '20.00',
      productImage: 'https://via.placeholder.com/150',
      quantity: '2',
    ),
  ];

  Widget createWidgetUnderTest() {
    final ApiService apiService = ApiService();
    final ProductRepository productRepository = ProductRepository(apiService);

    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => apiService),
        Provider<ProductRepository>(create: (context) => productRepository),
        Provider<GetProductsUseCase>(
          create:
              (context) => GetProductsUseCase(
                Provider.of<ProductRepository>(context, listen: false),
              ),
        ),
        ChangeNotifierProvider<HomeViewModel>.value(value: homeViewModel),
      ],
      child: MaterialApp(home: AllProductsView()),
    );
  }

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    homeViewModel = HomeViewModel(mockGetProductsUseCase);
  });

  group("all_products_view", () {
    testWidgets("loading", (WidgetTester tester) async {
      when(mockGetProductsUseCase.call()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 30),
          () => dummyProducts,
        ),
      );
      await homeViewModel.fetchProducts();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.text('No products found.'), findsNothing);
      // Let the loading complete
      await tester.pumpAndSettle();
    });

    testWidgets("all_products_view", (WidgetTester tester) async {
      when(
        mockGetProductsUseCase.call(),
      ).thenAnswer((_) async => dummyProducts);
      await homeViewModel.fetchProducts();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ProductGridItem), findsNWidgets(dummyProducts.length));
      expect(find.byType(LoadingIndicator), findsNothing);
      expect(find.text('No products found.'), findsNothing);
    });

    testWidgets(
      'AllProductsView displays "No products found." when product list is empty',
      (WidgetTester tester) async {
        // Configure mock to return an empty list
        when(mockGetProductsUseCase.call()).thenAnswer((_) async => []);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle(); // Wait for data fetching and UI rebuild
        expect(find.text('No products found.'), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
        expect(find.byType(LoadingIndicator), findsNothing);
      },
    );

    // Test error state
    testWidgets(
      'AllProductsView displays error message and retry button on error',
      (WidgetTester tester) async {
        // Configure mock to throw an exception
        when(
          mockGetProductsUseCase.call(),
        ).thenThrow(Exception('Network error'));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle(); // Wait for data fetching and UI rebuild

        // Verify error message and retry button are displayed
        expect(
          find.textContaining(
            'Failed to load products: Exception: Network error',
          ),
          findsOneWidget,
        );
        expect(find.byType(ElevatedButton), findsOneWidget); // Retry button
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
        expect(find.byType(LoadingIndicator), findsNothing);
      },
    );

    // Test retry button functionality
    testWidgets('Tapping retry button fetches products again', (
      WidgetTester tester,
    ) async {
      // First, make it fail
      when(mockGetProductsUseCase.call())
        ..thenThrow(Exception('Initial error'))
        ..thenAnswer((_) async => dummyProducts); // Then succeed on retry

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Error state

      // Verify error state
      expect(find.text('Retry'), findsOneWidget);

      // Tap retry button
      await tester.tap(find.text('Retry'));
      await tester.pump(); // Show loading again
      expect(find.byType(LoadingIndicator), findsOneWidget);
      await tester.pumpAndSettle(); // Load data

      // Verify that products are now displayed
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ProductGridItem), findsNWidgets(dummyProducts.length));
      expect(find.text('Retry'), findsNothing); // Retry button should be gone
    });

    // Test pull to refresh
    testWidgets('Pull to refresh fetches products again', (
      WidgetTester tester,
    ) async {
      // Configure mock to return products
      when(
        mockGetProductsUseCase.call(),
      ).thenAnswer((_) async => dummyProducts);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Load initial products

      // Drag to refresh (simulating pull to refresh)
      await tester.drag(find.byType(GridView), const Offset(0.0, 300.0));
      await tester.pump(); // Start the refresh indicator animation
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);

      // After a short delay, the refresh should complete
      await tester.pumpAndSettle();

      // Verify that fetchProducts was called twice (once initially, once on refresh)
      verify(mockGetProductsUseCase.call()).called(2);
    });
  });
}
