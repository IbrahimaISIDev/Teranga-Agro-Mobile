import 'package:flutter/material.dart';
import 'package:teranga_agro/features/marketplace/domain/usecases/add_product_usecase.dart';
import 'package:teranga_agro/features/marketplace/domain/usecases/update_product_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';

class MarketplaceProvider with ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  MarketplaceProvider(
    this.getProductsUseCase,
    this.getOrdersUseCase,
    this.updateOrderStatusUseCase,
    this.addProductUseCase,
    this.updateProductUseCase,
  ) {
    print('Main: Creating MarketplaceProvider...');
  }

  List<Product> _products = [];
  List<Order> _pendingOrders = [];
  List<Order> _historicalOrders = [];
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;

  List<Product> get products => _products;
  List<Order> get pendingOrders => _pendingOrders;
  List<Order> get historicalOrders => _historicalOrders;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getProductsUseCase();
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _products = [];
        print(
            'MarketplaceProvider: Failed to fetch products: ${failure.message}');
      },
      (products) {
        _products = products;
        print('MarketplaceProvider: Fetched ${products.length} products');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getOrdersUseCase();
    result.fold(
      (failure) {
        _isOffline = failure is OfflineFailure;
        _errorMessage = failure.message;
        _pendingOrders = [];
        _historicalOrders = [];
        print(
            'MarketplaceProvider: Failed to fetch orders: ${failure.message}');
      },
      (List<Order> orders) {
        _pendingOrders =
            orders.where((order) => order.status == 'pending').toList();
        _historicalOrders =
            orders.where((order) => order.status == 'delivered').toList();
        print(
            'MarketplaceProvider: Fetched ${orders.length} orders (${_pendingOrders.length} pending, ${_historicalOrders.length} delivered)');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateOrderStatus(int orderId, String status) async {
    _isLoading = true;
    notifyListeners();

    final result = await updateOrderStatusUseCase(orderId, status);
    bool success = result.isRight();

    if (success) {
      print(
          'MarketplaceProvider: Successfully updated order $orderId to $status');
      await fetchOrders();
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
      print(
          'MarketplaceProvider: Failed to update order status: $_errorMessage');
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    final result = await addProductUseCase(product);
    bool success = result.isRight();

    if (success) {
      await fetchProducts();
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    final result = await updateProductUseCase(product);
    bool success = result.isRight();

    if (success) {
      await fetchProducts();
    } else {
      _errorMessage = result.fold((failure) => failure.message, (_) => null);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
