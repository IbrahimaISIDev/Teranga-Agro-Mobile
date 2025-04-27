// lib/core/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'teranga_agro.db');
    print('DatabaseHelper: Initializing database at $path');

    return await openDatabase(
      path,
      version: 6, // Incrémenté à 6
      onCreate: (db, version) async {
        print('DatabaseHelper: Creating tables (version $version)');
        await db.execute('''
        CREATE TABLE parcelles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom TEXT NOT NULL,
          surface REAL NOT NULL,
          latitude REAL,
          longitude REAL
        )
      ''');
        await db.execute('''
        CREATE TABLE cultures (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          parcelleId INTEGER NOT NULL,
          nom TEXT NOT NULL,
          type TEXT NOT NULL,
          datePlantation TEXT NOT NULL,
          FOREIGN KEY (parcelleId) REFERENCES parcelles(id) ON DELETE CASCADE
        )
      ''');
        await db.execute('''
        CREATE TABLE suivis (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cultureId INTEGER NOT NULL,
          type TEXT NOT NULL,
          date TEXT NOT NULL,
          notes TEXT,
          FOREIGN KEY (cultureId) REFERENCES cultures(id) ON DELETE CASCADE
        )
      ''');
        await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          quantity REAL NOT NULL,
          price REAL NOT NULL,
          status TEXT NOT NULL
        )
      ''');
        await db.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          orderNumber TEXT NOT NULL,
          clientName TEXT NOT NULL,
          productName TEXT NOT NULL,
          quantity REAL NOT NULL,
          price REAL NOT NULL,
          status TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          phoneNumber TEXT NOT NULL,
          region TEXT NOT NULL
        )
      ''');

        print('DatabaseHelper: Inserting sample data');
        await _insertSampleData(db);

        // Insère un utilisateur par défaut
        await db.insert('users', {
          'id': 1,
          'name': 'Farmer Name',
          'phoneNumber': '+221771234567',
          'region': 'Dakar',
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print(
            'DatabaseHelper: Upgrading database from version $oldVersion to $newVersion');
        if (oldVersion < 2) {
          print(
              'DatabaseHelper: Creating products and orders tables for version 2');
          await db.execute('''
          CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            quantity REAL NOT NULL,
            price REAL NOT NULL,
            status TEXT NOT NULL
          )
        ''');
          await db.execute('''
          CREATE TABLE IF NOT EXISTS orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderNumber TEXT NOT NULL,
            clientName TEXT NOT NULL,
            productName TEXT NOT NULL,
            quantity REAL NOT NULL,
            price REAL NOT NULL,
            status TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
          await _insertSampleData(db);
        }
        if (oldVersion < 3) {
          print('DatabaseHelper: Applying version 3 migrations (if any)');
        }
        if (oldVersion < 4) {
          print(
              'DatabaseHelper: Applying version 4 migrations - fixing cultures table');
          final columns = await db.rawQuery('PRAGMA table_info(cultures)');
          bool hasParcelleId =
              columns.any((column) => column['name'] == 'parcelleId');

          if (!hasParcelleId) {
            print('DatabaseHelper: Adding parcelleId column to cultures table');
            await db.execute('''
              CREATE TABLE cultures_temp (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                parcelleId INTEGER NOT NULL,
                nom TEXT NOT NULL,
                type TEXT NOT NULL,
                datePlantation TEXT NOT NULL,
                FOREIGN KEY (parcelleId) REFERENCES parcelles(id) ON DELETE CASCADE
              )
            ''');
            await db.execute('''
              INSERT INTO cultures_temp (id, nom, type, datePlantation)
              SELECT id, nom, type, datePlantation FROM cultures
            ''');
            await db.execute('DROP TABLE cultures');
            await db.execute('ALTER TABLE cultures_temp RENAME TO cultures');
            print('DatabaseHelper: Successfully migrated cultures table');
          }
        }
        if (oldVersion < 5) {
          print(
              'DatabaseHelper: Applying version 5 migrations - fixing cultures table columns');
          final columns = await db.rawQuery('PRAGMA table_info(cultures)');
          bool hasDatePlantation =
              columns.any((column) => column['name'] == 'datePlantation');
          bool hasDate_plantation =
              columns.any((column) => column['name'] == 'date_plantation');

          if (hasDate_plantation && !hasDatePlantation) {
            print(
                'DatabaseHelper: Renaming date_plantation to datePlantation in cultures table');
            await db.execute('''
              CREATE TABLE cultures_temp (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                parcelleId INTEGER NOT NULL,
                nom TEXT NOT NULL,
                type TEXT NOT NULL,
                datePlantation TEXT NOT NULL,
                FOREIGN KEY (parcelleId) REFERENCES parcelles(id) ON DELETE CASCADE
              )
            ''');
            await db.execute('''
              INSERT INTO cultures_temp (id, parcelleId, nom, type, datePlantation)
              SELECT id, parcelleId, nom, type, date_plantation FROM cultures
            ''');
            await db.execute('DROP TABLE cultures');
            await db.execute('ALTER TABLE cultures_temp RENAME TO cultures');
            print(
                'DatabaseHelper: Successfully renamed date_plantation to datePlantation');
          } else if (!hasDatePlantation) {
            print(
                'DatabaseHelper: Adding datePlantation column to cultures table');
            await db
                .execute('ALTER TABLE cultures ADD COLUMN datePlantation TEXT');
            await db.execute(
                "UPDATE cultures SET datePlantation = '2025-01-01' WHERE datePlantation IS NULL");
            print('DatabaseHelper: Successfully added datePlantation column');
          }
        }
      },
    );
  }

  Future<void> _insertSampleData(Database db) async {
    final productCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM products'));
    if (productCount == 0) {
      await db.insert('products', {
        'name': 'Maïs',
        'quantity': 250.0,
        'price': 750.0,
        'status': 'En vente',
      });
      await db.insert('products', {
        'name': 'Tomates',
        'quantity': 180.0,
        'price': 1800.0,
        'status': 'En vente',
      });
      await db.insert('products', {
        'name': 'Manioc',
        'quantity': 120.0,
        'price': 1200.0,
        'status': 'Suspendu',
      });
    }

    final orderCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders'));
    if (orderCount == 0) {
      await db.insert('orders', {
        'orderNumber': '0034',
        'clientName': 'Restaurant Le Baobab',
        'productName': 'Maïs',
        'quantity': 50.0,
        'price': 37500.0,
        'status': 'pending',
        'date': '25/02/2025',
      });
      await db.insert('orders', {
        'orderNumber': '0033',
        'clientName': 'Marché Central',
        'productName': 'Tomates',
        'quantity': 70.0,
        'price': 126000.0,
        'status': 'delivered',
        'date': '24/02/2025',
      });
    }
  }

  Future<Map<String, dynamic>?> getUser(int id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'teranga_agro.db');
    await deleteDatabase(path);
    _database = null;
    await database;
  }

  Future<void> debugDatabaseTables() async {
    final db = await database;

    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;");
    print(
        'DatabaseHelper: Tables dans la base de données: ${tables.map((t) => t['name']).toList()}');

    for (var table in tables) {
      final tableName = table['name'] as String;
      if (!tableName.startsWith('sqlite_') &&
          !tableName.startsWith('android_')) {
        final columns = await db.rawQuery('PRAGMA table_info($tableName)');
        print('DatabaseHelper: Table $tableName colonnes: $columns');

        final count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
        print('DatabaseHelper: Table $tableName contient $count lignes');
      }
    }
  }
}