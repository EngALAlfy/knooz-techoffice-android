import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:techoffice/models/Order.dart';

class DBProvider extends ChangeNotifier {
  List<Order> currentOrders;
  List<Order> finishedOrders;
  List<Order> stoppedOrders;
  List<Order> archivedOrders;
  List<Order> tabledOrders;

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'orders_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE orders(id INTEGER PRIMARY KEY,number INTEGER UNIQUE, project TEXT,notes TEXT,problems TEXT,status TEXT, count INTEGER, done_count INTEGER, shipped_count INTEGER, archived INTEGER,finishing TEXT,material TEXT,order_date TEXT,finish_date TEXT,start_date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertOrder(Order order) async {
    // Get a reference to the database.
    final db = await database();

    await db.insert(
      'orders',
      order.toJson(),
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> updateDone(id, done) async {
    // Get a reference to the database.
    final db = await database();

    await db.update(
      'orders',
      {'done_count': done},
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> updateShipped(id, shipped) async {
    // Get a reference to the database.
    final db = await database();

    await db.update(
      'orders',
      {'shipped_count': shipped},
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> updateProblems(id, problems) async {
    // Get a reference to the database.
    final db = await database();

    await db.update(
      'orders',
      {'problems': problems},
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> updateNotes(id, notes) async {
    // Get a reference to the database.
    final db = await database();

    await db.update(
      'orders',
      {'notes': notes},
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> archiveOrder(id) async {
    // Get a reference to the database.
    final db = await database();

    await db.update(
      'orders',
      {'archived': 1},
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> stopOrder(id) async {
    // Get a reference to the database.
    final db = await database();

    var date = DateTime.now();
    await db.update(
      'orders',
      {
        'status': 'stopped',
        'finish_date': "${date.year}-${date.month}-${date.day}"
      },
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> finishOrder(id) async {
    // Get a reference to the database.
    final db = await database();
    var date = DateTime.now();
    await db.update(
      'orders',
      {
        'status': 'finished',
        'finish_date': "${date.year}-${date.month}-${date.day}"
      },
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getCurrentOrders();
  }

  Future<void> startOrder(id) async {
    // Get a reference to the database.
    final db = await database();

    await db.update(
      'orders',
      {'status': 'started'},
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    getCurrentOrders();
    getStoppedOrders();
    getFinishedOrders();
  }

  Future<void> unArchiveOrder(id) async {
    // Get a reference to the database.
    final db = await database();

    await db.update(
      'orders',
      {'archived': 0},
      where: 'id = ?',
      whereArgs: [id],
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );

    getCurrentOrders();
    getArchivedOrders();
  }

  getCurrentOrders() async {
    // Get a reference to the database.
    final db = await database();

    final List<Map<String, dynamic>> maps =
        await db.query('orders', where: 'archived = 0 and status = "started"');

    currentOrders =
        maps.map((e) => e == null ? null : Order.fromJson(e)).toList();

    notifyListeners();
  }

  getTabledOrders() async {
    // Get a reference to the database.
    final db = await database();

    final List<Map<String, dynamic>> maps =
        await db.query('orders', where: 'archived = 0 and status = "started"');

    tabledOrders =
        maps.map((e) => e == null ? null : Order.fromJson(e)).toList();

    notifyListeners();
  }

  getStoppedOrders() async {
    // Get a reference to the database.
    final db = await database();

    final List<Map<String, dynamic>> maps =
        await db.query('orders', where: 'archived = 0 and status = "stopped"');

    stoppedOrders =
        maps.map((e) => e == null ? null : Order.fromJson(e)).toList();

    notifyListeners();
  }

  getFinishedOrders() async {
    // Get a reference to the database.
    final db = await database();

    final List<Map<String, dynamic>> maps =
        await db.query('orders', where: 'archived = 0 and status = "finished"');

    finishedOrders =
        maps.map((e) => e == null ? null : Order.fromJson(e)).toList();

    notifyListeners();
  }

  getArchivedOrders() async {
    // Get a reference to the database.
    final db = await database();

    final List<Map<String, dynamic>> maps =
        await db.query('orders', where: 'archived = 1');

    archivedOrders =
        maps.map((e) => e == null ? null : Order.fromJson(e)).toList();

    notifyListeners();
  }

  Future<void> deleteOrder(id) async {
    // Get a reference to the database.
    final db = await database();

    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    getCurrentOrders();
    getFinishedOrders()();
    getStoppedOrders();
    getArchivedOrders();
  }
}
