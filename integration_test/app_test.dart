
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_test/app/app_constants.dart';
import 'package:test_test/app/app_keys.dart';
import 'package:test_test/main.dart' as app;
import 'package:test_test/presentation/home/widget/product_grid_item.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("integration_test", () {
    testWidgets("Full App Flow", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login
      expect(find.text("Login"), findsOneWidget);
      expect(find.byKey(AppKeys.usernameFieldKey), findsOneWidget);
      expect(find.byKey(AppKeys.passwordFieldKey), findsOneWidget);
      expect(find.byKey(AppKeys.loginButtonKey), findsOneWidget);
      //
      await tester.enterText(
        find.byKey(AppKeys.usernameFieldKey),
        AppConstants.validUsername,
      );
      await tester.enterText(
        find.byKey(AppKeys.passwordFieldKey),
        AppConstants.validPassword,
      );
      // tester.testTextInput.hide();
      await tester.pumpAndSettle();
      print('Tapped login button, waiting for home screen...1');

      await tester.tap(find.byKey(AppKeys.loginButtonKey));
      print('Tapped login button, waiting for home screen...2');

      await tester.pump(); // starts login animation
      await tester.pump(const Duration(seconds: 1));
      print('Tapped login button, waiting for home screen...3');
      // optional wait
      await tester.pumpAndSettle();
      print('Tapped login button, waiting for home screen...4');

      //Home Screen

      expect(find.byIcon(Icons.grid_on), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
      await Future.delayed(const Duration(seconds: 4));

      await tester.fling(
        find.byType(GridView),
        const Offset(0.0, -300.0),
        1000,
      );
      await tester.pump();
      await tester.pump(Duration(seconds: 4));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(AppKeys.addProductButtonKey));
      await tester.pumpAndSettle();
      //  await tester.pump();
      // await tester.pump(Duration(seconds: 4));
      //add screen

      expect(find.text('Add New Product'), findsOneWidget);
      await tester.enterText(find.byKey(AppKeys.productNameFieldKey), "text");
      await tester.enterText(
        find.byKey(AppKeys.productImageFieldKey),
        "https://raw.githubusercontent.com/HemKumarRai/assets/refs/heads/main/Screenshot%202025-04-16%20at%2009.34.41.png",
      );
      await tester.enterText(find.byKey(AppKeys.productQuantityFieldKey), "4");
      await tester.enterText(find.byKey(AppKeys.productPriceFieldKey), "400");

      await tester.tap(find.byKey(AppKeys.addProductButtonKey));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("text"), findsOneWidget);

      final Finder productToFavorite = find.byWidgetPredicate(
        (widget) => widget is ProductGridItem && widget.product.name == "text",
      );

      expect(productToFavorite, findsOneWidget);

      // Find the favorite button for that specific product
      final Finder favoriteButton = find.descendant(
        of: productToFavorite,
        matching: find.byIcon(Icons.favorite_border),
      );

      // Tap the favorite button
      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      // Verify the icon changed to filled heart
      expect(
        find.descendant(
          of: productToFavorite,
          matching: find.byIcon(Icons.favorite),
        ),
        findsOneWidget,
      );

      // 5. Navigate to Favorites Tab and Verify
      await tester.tap(
        find.byIcon(Icons.favorite).last,
      ); // Tap the Favorites tab in BottomNavBar
      await tester.pumpAndSettle(); // Wait for tab transition

      // Verify that the new product is visible in the Favorites list
      expect(find.text("text"), findsOneWidget);
      expect(find.text('\$${"400"}'), findsOneWidget);
      expect(find.text('Quantity: ${"4"}'), findsOneWidget);

      // Verify the favorite icon on the favorite list item is red/filled
      expect(
        find.descendant(
          of: find.text("text").first,
          matching: find.byIcon(Icons.favorite),
        ),
        findsOneWidget,
      );

      // 6. Remove product from favorites
      final Finder favListItem = find.byWidgetPredicate(
        (widget) =>
            widget is Card &&
            find
                .descendant(
                  of: find.byWidget(widget),
                  matching: find.text("text"),
                )
                .evaluate()
                .isNotEmpty,
      );
      expect(favListItem, findsOneWidget);

      final Finder removeFavButton = find.descendant(
        of: favListItem,
        matching: find.byIcon(Icons.favorite),
      );

      await tester.tap(removeFavButton);
      await tester.pumpAndSettle();

      // Verify the product is no longer in the favorites list
      expect(find.text("text"), findsNothing);
      expect(
        find.text(
          'No favorite products yet. Add some from the All Products tab!',
        ),
        findsOneWidget,
      );
    });
  });
}
