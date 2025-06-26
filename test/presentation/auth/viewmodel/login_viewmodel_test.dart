import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_test/app/app_constants.dart';
import 'package:test_test/presentation/auth/viewmodel/login_viewmodel.dart';

void main(){
  late LoginViewModel loginViewModel;
  setUp((){
    loginViewModel = LoginViewModel();
  });

  group("Test LoginViewModel ", (){
    test("Check all initial value", (){
      expect(loginViewModel.username, "");
      expect(loginViewModel.password, "");
      expect(loginViewModel.isLoading,false);
      expect(loginViewModel.errorMessage,null);
    });
    
    test("setUserName", (){
      loginViewModel.setUsername("AAA");
      expect(loginViewModel.username, "AAA");
    });

    test('setPassword',(){
      loginViewModel.setPassword("aaaaa");
      expect(loginViewModel.password, "aaaaa");
      expect(loginViewModel.errorMessage, isNull);
    });

    test("login Passed Case Test", ()async{
      loginViewModel.setPassword(AppConstants.validPassword);
      loginViewModel.setUsername(AppConstants.validUsername);
      Future<bool> future = loginViewModel.login();
      loginViewModel.setLoading(true);
      final response = await future;
      loginViewModel.setLoading(false);
      expect(response, true);
      expect(loginViewModel.errorMessage, null);
    });

    test("login failed due to username mis",()async{
      loginViewModel.setUsername("wrong");
      loginViewModel.setPassword(AppConstants.validPassword);
      Future<bool> future = loginViewModel.login();
      loginViewModel.setLoading(true);
      final res=await future;
      loginViewModel.setLoading(false);
      expect(res, false);
      expect(loginViewModel.errorMessage, isNotNull);
    });
  });
}