import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_test/app/app_constants.dart';
import 'package:test_test/app/app_keys.dart';
import 'package:test_test/app/app_routes.dart';
import 'package:test_test/data/repositories/product_repository.dart';
import 'package:test_test/data/services/api_service.dart' show ApiService;
import 'package:test_test/domain/usecases/get_products_usecase.dart';
import 'package:test_test/presentation/auth/view/login_screen.dart';
import 'package:test_test/presentation/auth/viewmodel/login_viewmodel.dart';
import 'package:test_test/presentation/home/viewmodel/home_viewmodel.dart';

void main() {
  Widget createWidgetUnderTest() {
    final apiService = ApiService();
    final productRepository = ProductRepository(apiService);

    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => apiService),
        // Provide ProductRepository globally
        Provider<ProductRepository>(create: (_) => productRepository),
        // Provide UseCases
        Provider<GetProductsUseCase>(
          create:
              (context) => GetProductsUseCase(
                Provider.of<ProductRepository>(context, listen: false),
              ),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(),
        ),

        ChangeNotifierProvider<HomeViewModel>(
          create:
              (context) => HomeViewModel(
                Provider.of<GetProductsUseCase>(context, listen: false),
              ),
        ),
      ],
      child: MaterialApp(
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.login,
      ),
    );
  }

  group("Testing LoginScreen", () {
    testWidgets("Login Display widget test", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("Login"), findsOneWidget);
      expect(find.byKey(AppKeys.usernameFieldKey), findsOneWidget);
      expect(find.byKey(AppKeys.passwordFieldKey), findsOneWidget);
      expect(find.byKey(AppKeys.loginButtonKey), findsOneWidget);
    });

    testWidgets("Check validity of button navigation", (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(
        find.byKey(AppKeys.usernameFieldKey),
        AppConstants.validUsername,
      );
      await tester.enterText(
        find.byKey(AppKeys.passwordFieldKey),
        AppConstants.validPassword,
      );
      await tester.tap(find.byKey(AppKeys.loginButtonKey));
      await tester.pumpAndSettle();
      expect(find.text("Everest Shop"), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets("Error while not giving input", (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byKey(AppKeys.loginButtonKey));
      await tester.pump();
      expect(find.text("Please enter your username"), findsOneWidget);
      expect(find.text("Please enter your password"), findsOneWidget);
    });


    // Test loading indicator
    testWidgets('Loading indicator is shown during login attempt', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid credentials
      await tester.enterText(find.byKey(const ValueKey('usernameField')), AppConstants.validUsername);
      await tester.enterText(find.byKey(const ValueKey('passwordField')), AppConstants.validPassword);

      // Tap the login button
      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pump(); // Pump once to trigger loading state

      // Verify that the CircularProgressIndicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Verify that the login button is not visible when loading
      expect(find.byKey(const ValueKey('loginButton')), findsNothing);

      await tester.pumpAndSettle(); // Wait for navigation to complete
      // After navigation, the indicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Failed login displays error message', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid credentials
      await tester.enterText(find.byKey(const ValueKey('usernameField')), 'invalid@example.com');
      await tester.enterText(find.byKey(const ValueKey('passwordField')), 'wrongpass');

      // Tap the login button
      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pump(); // Pump to show loading indicator
      await tester.pumpAndSettle(); // Pump again to allow async operation to complete and UI to update

      // Verify that an error message is displayed
      expect(find.text('Invalid username or password.'), findsOneWidget);
      // Verify that it did not navigate away
      expect(find.byType(LoginScreen), findsOneWidget);
    });


  });
}
