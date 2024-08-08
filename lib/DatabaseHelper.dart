import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'localdb.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            name TEXT,
            address TEXT,
            designation TEXT,
            phone_no INTEGER,
            email TEXT,
            otp INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByPhone(int phoneNo) async {
    final db = await database;
    final result = await db.query('users', where: 'phone_no = ?', whereArgs: [phoneNo]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUserOtp(int phoneNo, int otp) async {
    final db = await database;
    final user = await getUserByPhone(phoneNo);

    if (user != null) {

      return await db.update(
        'users',
        {'otp': otp},
        where: 'phone_no = ?',
        whereArgs: [phoneNo],
      );
    } else {

      final newUser = {
        'phone_no': phoneNo,
        'otp': otp,
      };
      return await insertUser(newUser);
    }
  }
}
