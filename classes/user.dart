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
