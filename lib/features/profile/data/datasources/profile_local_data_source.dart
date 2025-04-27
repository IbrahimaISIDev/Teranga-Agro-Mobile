import 'package:sqflite/sqflite.dart';
import '../../../../core/storage/database.dart';
import '../models/user_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserModel> getUser();
  Future<void> updateUser(UserModel user);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<UserModel> getUser() async {
    final db = await DatabaseHelper.instance.database;
    final userMaps = await db.rawQuery('SELECT * FROM users WHERE id = 1');
    if (userMaps.isEmpty) {
      // Insert default user if none exists
      await db.insert('users', {
        'id': 1,
        'name': 'Farmer Name',
        'phoneNumber': '+221771234567',
        'region': 'Dakar',
      });
      return UserModel(
        id: 1,
        name: 'Farmer Name',
        phoneNumber: '+221771234567',
        region: 'Dakar',
      );
    }
    return UserModel.fromJson(userMaps.first);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}