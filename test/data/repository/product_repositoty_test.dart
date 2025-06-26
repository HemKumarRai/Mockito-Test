import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_test/app/app_constants.dart';
import 'package:test_test/data/models/product.dart';
import 'package:test_test/data/repositories/product_repository.dart';
import 'package:test_test/data/services/api_service.dart';
import 'product_repositoty_test.mocks.dart';
@GenerateMocks([ApiService])
void main(){
  late ProductRepository productRepository;
  late MockApiService mockApiService;
  group("Product repository test", (){
    final endpoint = "/products.json";
   setUp((){
     mockApiService = MockApiService();
     productRepository = ProductRepository(mockApiService);
   });


    test("test get all products", ()async{
      final mockRes = {"-O1rMOKitY0ofhY53Jhv":{"id":"-O1rMOKitY0ofhY53Jhv","name":"Real Product222","price":"40000","productImage":"https://www.si.com/.image/t_share/MTY4MTAyOTQ5MjU3MjkxMTM2/2014-0401-neymarjpg.jpg","quantity":"4"},"-O1rSbVYw2_txaHh3P8K":{"id":"1721064912245000","name":"My Product","price":"40000","productImage":"https://upload.wikimedia.org/wikipedia/commons/b/bb/Neymar_Jr._with_Al_Hilal%2C_3_October_2023_-_03_%28cropped%29.jpg","quantity":"4"},"-O1tbn9uR98Aa37K0ko0":{"id":"-O1tbn9uR98Aa37K0ko0","name":"gdgd","price":"2580.0","productImage":"https://www.si.com/.image/t_share/MTY4MTAyOTQ5MjU3MjkxMTM2/2014-0401-neymarjpg.jpg","quantity":"6"},"-O1ulJ8PzTXdkvovhLVL":{"id":"1721120407405027","name":"hello","price":"258.0","productImage":"yyfyf?fuuuu","quantity":"25"}};
      when(mockApiService.get(endpoint)).thenAnswer((_)async=>mockRes);
      final response =await productRepository.getProducts();
      expect(response.length, 4);
    });

    test("Throw Exception", (){
      when(mockApiService.get(endpoint)).thenThrow(Exception());
      expect(productRepository.getProducts(), throwsException);
    });

    test("Add new product", (){
      final product = Product(name: "name", price: "price", productImage: "productImage", quantity: "quantity");
      when(mockApiService.post(endpoint, product.toJson())).thenAnswer((_)async=>{"status":"Added"});
      final response = productRepository.addProduct(product);
      verify(mockApiService.post(endpoint, product.toJson())).called(1);
    });

    test("Excepttion New Product", (){
      final product = Product(name: "name", price: "price", productImage: "productImage", quantity: "quantity");
when(mockApiService.post(endpoint, product.toJson())).thenThrow((_)=>Exception("Api not working"));
expect(productRepository.addProduct(product), throwsException);
    });
  });
}