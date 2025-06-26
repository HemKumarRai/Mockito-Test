
class Product {
  final String? id; // Nullable as it might not be present when creating a new product
  final String name;
  final String price;
  final String productImage;
  final String quantity;

  // Constructor for the Product class
  Product({
    this.id, // Optional ID for existing products
    required this.name,
    required this.price,
    required this.productImage,
    required this.quantity,
  });

  // Factory method to create a Product instance from a JSON map
  factory Product.fromJson(Map<String, dynamic> json, {String? id}) {
    return Product(
      id: id ?? json['id'] as String?, // Use provided id or 'id' from JSON
      name: json['name'] as String,
      price: json['price'] as String,
      productImage: json['productImage'] as String,
      quantity: json['quantity'] as String,
    );
  }

  // Method to convert a Product instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include ID if available
      'name': name,
      'price': price,
      'productImage': productImage,
      'quantity': quantity,
    };
  }

  // Method to create a copy of Product with optional new values
  Product copyWith({
    String? id,
    String? name,
    String? price,
    String? productImage,
    String? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      productImage: productImage ?? this.productImage,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, productImage: $productImage, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.productImage == productImage &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    price.hashCode ^
    productImage.hashCode ^
    quantity.hashCode;
  }
}
