import 'user.dart';
import 'product.dart';
import 'invoice.dart';

class Store {
  List<User> users = [];
  List<Product> products = [];
  List<Invoice> invoices = [];
  double income = 0;

  Store();

  User addUser({required String user_name, required double budget}) {
    User user = new User(id: users.length, name: user_name, budget: budget);
    users.add(user);
    return user;
  }

  User getUser({required int id}) {
    return users.firstWhere((user) => user.id == id);
  }

  bool userExists({required int id}) {
    try {
      getUser(id: id);
      return true;
    } catch (StandardError) {
      return false;
    }
  }

  Product getProduct({required int id}) {
    return products.firstWhere((product) => product.id == id);
  }

  bool productExists({required int id}) {
    try {
      getProduct(id: id);
      return true;
    } catch (StandardError) {
      return false;
    }
  }

  Product addProduct(
      {required String name, required int quantity, required double price}) {
    Product product = new Product(
        id: products.length, name: name, quantity: quantity, price: price);
    products.add(product);
    return product;
  }

  Invoice addInvoice({required String name}) {
    Invoice invoice = new Invoice(id: invoices.length, name: name);
    invoices.add(invoice);
    return invoice;
  }

  void addIncome({required Invoice invoice}) {
    income += invoice.total;
  }
}
