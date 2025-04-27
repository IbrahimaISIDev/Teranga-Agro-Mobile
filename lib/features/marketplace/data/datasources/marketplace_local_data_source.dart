import 'package:sqflite/sqflite.dart';
import '../../../../core/storage/database.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

abstract class MarketplaceLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<OrderModel>> getOrders();
  Future<void> updateOrderStatus(int orderId, String status);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
}

class MarketplaceLocalDataSourceImpl implements MarketplaceLocalDataSource {
  final DatabaseHelper databaseHelper;

  MarketplaceLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final db = await databaseHelper.database;
      final productsMaps = await db.rawQuery('SELECT * FROM products');
      print(
          'MarketplaceLocalDataSource: Fetched ${productsMaps.length} products');
      return productsMaps.map((map) => ProductModel.fromJson(map)).toList();
    } catch (e) {
      print('MarketplaceLocalDataSource: Error fetching products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final db = await databaseHelper.database;
      final ordersMaps =
          await db.rawQuery('SELECT * FROM orders ORDER BY date DESC');
      print('MarketplaceLocalDataSource: Fetched ${ordersMaps.length} orders');
      return ordersMaps.map((map) => OrderModel.fromJson(map)).toList();
    } catch (e) {
      print('MarketplaceLocalDataSource: Error fetching orders: $e');
      throw Exception('Failed to fetch orders: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'orders',
        {'status': status},
        where: 'id = ?',
        whereArgs: [orderId],
      );
      print(
          'MarketplaceLocalDataSource: Updated order $orderId to status $status');
    } catch (e) {
      print('MarketplaceLocalDataSource: Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('products', product.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'products',
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }
}
