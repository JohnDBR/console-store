import 'dart:io';

void main() {
  bool exit = false;
  Store store = new Store();
  store.addUser(user_name: 'John', budget: 1500);
  store.addProduct(name: 'Papa', quantity: 12, price: 200);
  store.addProduct(name: 'Yuca', quantity: 20, price: 500);
  store.addProduct(name: 'Ñame', quantity: 5, price: 300);
  store.addProduct(name: 'Queso', quantity: 3, price: 1500);

  print('...');
  print('Hello JohnDi! :)');

  while (!exit) {
    print('-------------------- [APP MENU]');
    print('0) Exit');
    print('1) Store List');
    print('2) Purchase');
    print('3) Purchase List');
    print('4) Client List');
    print('5) Register Client');
    print('6) Resupply');

    int option = ConsoleHelper.getIntSafely();
    switch (option) {
      case 0:
        print('Goodbye JohnDi! :)');
        print('...');
        exit = !exit;
        break;
      case 1:
        print('1) Store List --------------------');
        print('Store Income: \$${store.income}');
        store.products.forEach((product) {
          print('  ------ [PRODUCT] ${product.id}');
          print('  ${product.name}');
          print('  ${product.quantity}');
          print('  \$${product.price}');
        });
        break;
      case 2:
        print('2) Purchase --------------------');
        bool exit_submenu = false;
        Invoice? invoice = null;
        User? user = null;
        print('  user_id -');
        int user_id = ConsoleHelper.getIntSafely(stack: 1);
        if (store.userExists(id: user_id)) {
          user = store.getUser(id: user_id);
        } else {
          print('  Wrong user!');
          break;
        }

        while (!exit_submenu) {
          print('  2.1) Add product');
          print('  2.2) Exit');

          String submenu_option = ConsoleHelper.getStringSafely(stack: 1);

          if (submenu_option == '2.1') {
            print('  id -');
            int product_id = ConsoleHelper.getIntSafely(stack: 1);

            if (store.productExists(id: product_id)) {
              Product product = store.getProduct(id: product_id);

              print('  quantity -');
              int product_quantity = ConsoleHelper.getIntSafely(stack: 1);

              if (user.budgetEnough(
                  price: product.price, quantity: product_quantity)) {
                if (invoice == null) {
                  invoice = store.addInvoice(name: user.name);
                }
                user.purchase(price: product.price, quantity: product_quantity);
                invoice.addProduct(
                    product: product.saveReference(quantity: product_quantity));
              } else {
                print('  Not enough budget!');
              }
            } else {
              print('  Wrong product!');
            }
          } else {
            if (invoice != null) {
              store.addIncome(invoice: invoice);
            }
            exit_submenu = !exit_submenu;
          }
        }
        break;
      case 3:
        print('3) Purchase List --------------------');
        store.invoices.forEach((invoice) {
          print('  ------ [INVOICE] ${invoice.id}');
          print('  ${invoice.name}');
          print('  ${invoice.items}');
          print('  \$${invoice.total}');
          invoice.products.forEach((product) {
            print('    ------ [PRODUCT] ${product.id}');
            print('    ${product.name}');
            print('    ${product.quantity}');
          });
        });
        break;
      case 4:
        print('4) Client List --------------------');
        store.users.forEach((user) {
          print('  ------ [USER] ${user.id}');
          print('  ${user.name}');
          print('  \$${user.budget}');
        });
        break;
      case 5:
        print('5) Register Client --------------------');
        print('  id -');
        int user_id = ConsoleHelper.getIntSafely(stack: 1);
        User? user = null;
        String? user_name = null;
        if (store.userExists(id: user_id)) {
          print(' -- [EDIT] --');
          user = store.getUser(id: user_id);
        } else {
          print(' -- [CREATE] --');
          print('  name -');
          user_name = ConsoleHelper.getStringSafely(stack: 1);
        }
        print('  budget -');
        double user_budget = ConsoleHelper.getDoubleSafely(stack: 1);
        if (user != null) {
          user.budget = user_budget;
        } else if (user_name != null) {
          store.addUser(user_name: user_name, budget: user_budget);
        }
        break;
      case 6:
        print('6) Resupply --------------------');
        print('  id -');
        int product_id = ConsoleHelper.getIntSafely(stack: 1);
        Product? product = null;
        String? product_name = null;
        if (store.productExists(id: product_id)) {
          print(' -- [EDIT] --');
          product = store.getProduct(id: product_id);
        } else {
          print(' -- [CREATE] --');
          print('  name -');
          product_name = ConsoleHelper.getStringSafely(stack: 1);
        }
        print('  quantity -');
        int product_quantity = ConsoleHelper.getIntSafely(stack: 1);
        print('  price -');
        double product_price = ConsoleHelper.getDoubleSafely(stack: 1);
        if (product != null) {
          product.quantity = product_quantity;
          product.price = product_price;
        } else if (product_name != null) {
          store.addProduct(name: product_name, quantity: product_quantity, price: product_price);
        }
        break;
      default:
        break;
    }
  }
}

class ConsoleHelper {
  static int getIntSafely({int stack = 0, int deft = -1}) {
    String stack_string = String.fromCharCodes(
        Iterable.generate(stack * 2, (_) => ' '.codeUnits.first));
    try {
      return int.parse(stdin.readLineSync().toString());
    } catch (StandardError) {
      print('${stack_string}Wrong!');
    }
    return deft;
  }

  static double getDoubleSafely({int stack = 0, double deft = -1}) {
    String stack_string = String.fromCharCodes(
        Iterable.generate(stack * 2, (_) => ' '.codeUnits.first));
    try {
      return double.parse(stdin.readLineSync().toString());
    } catch (StandardError) {
      print('${stack_string}Wrong!');
    }
    return deft;
  }

  static String getStringSafely({int stack = 0, String deft = ''}) {
    String stack_string = String.fromCharCodes(
        Iterable.generate(stack * 2, (_) => ' '.codeUnits.first));
    try {
      return stdin.readLineSync().toString();
    } catch (StandardError) {
      print('${stack_string}Wrong!');
    }
    return deft;
  }
}

class User {
  final int id;
  String name;
  double budget;

  User(
      {required int this.id,
      required String this.name,
      required double this.budget});

  bool budgetEnough({required double price, required int quantity}) {
    return (budget - (price * quantity)) >= 0;
  }

  void purchase({required double price, required int quantity}) {
    budget -= (price * quantity);
  }
}

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
