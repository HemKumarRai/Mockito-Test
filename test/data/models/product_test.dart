

import 'package:flutter_test/flutter_test.dart';
import 'package:test_test/data/models/product.dart';

void main(){
  group("Product Model",(){
test("Product From Json", (){
  final Map<String,dynamic> remoteJson ={
    'id': '1',
    'name': 'Test Product',
    'price': '100.00',
    'productImage': 'http://example.com/image.jpg',
    'quantity': '10',
  };

  final product = Product.fromJson(remoteJson);

  expect(product.id, "1");
  expect(product.name, "Test Product");
  expect(product.price, "100.00");
  expect(product.quantity, "10");
  expect(product.productImage, "http://example.com/image.jpg");
});

test("toJson must be able to convert object to Map", (){
  final product = Product(name: "name", price: "price", productImage: "productImage", quantity: "quantity",id: "2");
  final productToJson = product.toJson();
  expect(productToJson["id"], "2");
  expect(productToJson["name"], "name");
  expect(productToJson["price"], "price");
  expect(productToJson["productImage"], "productImage");
  expect(productToJson["quantity"], "quantity");
  print("success");
});
  },);
}