import '../../domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.orderNumber,
    required super.clientName,
    required super.productName,
    required super.quantity,
    required super.price,
    required super.status,
    required super.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      orderNumber: json['orderNumber'] as String,
      clientName: json['clientName'] as String,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'clientName': clientName,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'status': status,
      'date': date,
    };
  }
}