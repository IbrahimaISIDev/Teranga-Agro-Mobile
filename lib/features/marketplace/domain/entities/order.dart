class Order {
  final int id;
  final String orderNumber;
  final String clientName;
  final String productName;
  final double quantity;
  final double price;
  final String status;
  final String date;

  Order({
    required this.id,
    required this.orderNumber,
    required this.clientName,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.status,
    required this.date,
  });
}