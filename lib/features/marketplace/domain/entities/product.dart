class Product {
  final int id;
  final String name;
  final double quantity;
  final double price;
  final String status;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.status,
  });

  get imageUrl => null;
}