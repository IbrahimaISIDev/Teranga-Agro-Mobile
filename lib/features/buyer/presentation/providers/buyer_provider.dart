import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/place_order_usecase.dart';

class BuyerProvider with ChangeNotifier {
  final GetOrdersUseCase getOrdersUseCase;
  final PlaceOrderUseCase placeOrderUseCase;

  BuyerProvider(this.getOrdersUseCase, this.placeOrderUseCase);

  List<Order> _orders = [];
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getOrdersUseCase();
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _orders = [];
      },
      (orders) {
        _orders = orders.cast<Order>();
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> placeOrder(int productId, String productName, int quantity, double totalPrice) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await placeOrderUseCase(productId, productName, quantity, totalPrice);
    bool success = result.isRight();

    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
      },
      (_) {
        _errorMessage = null;
        fetchOrders(); // Refresh orders after placing a new one
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}