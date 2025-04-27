class Order {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double totalPrice;
  final String status;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
  });
}