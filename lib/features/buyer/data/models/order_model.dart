import '../../domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.totalPrice,
    required super.status,
    required super.orderDate,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      status: map['status'],
      orderDate: DateTime.parse(map['orderDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
    };
  }
}