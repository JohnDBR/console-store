import 'product.dart';

class Invoice {
  final int id;
  String name;
  List<Product> products = [];
  int items = 0;
  double total = 0;

  Invoice({required int this.id, required String this.name});

  void process() {
    items = 0;
    total = 0;
    products.forEach((product) {
      items += product.quantity;
      total += (product.quantity * product.price);
    });
  }

  Product addProduct({required Product product}) {
    items += product.quantity;
    total += (product.quantity * product.price);
    products.add(product);
    return product;
  }
}
