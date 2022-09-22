class Product {
  final int id;
  String name;
  int quantity;
  double price;

  Product(
      {required int this.id,
      required String this.name,
      required int this.quantity,
      required double this.price});

  Product saveReference({required int quantity}) {
    this.quantity = this.quantity - quantity;
    return new Product(
        id: this.id, name: name, quantity: quantity, price: this.price);
  }
}
