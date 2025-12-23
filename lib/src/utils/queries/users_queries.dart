import 'package:tachkil/src/models/user_model.dart';
import 'package:tachkil/src/utils/database_helper.dart';

class UsersQueries {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // insert new user
  Future<int> insert(UserModel userModel) async {
    final db = await _dbHelper.getDBInstance();

    int rep = await db.insert('users', userModel.toMap());
    _dbHelper.closeDb();
    return rep;
  }

  // update the user
  Future<int> update(int userId, String username, String password) async {
    final db = await _dbHelper.getDBInstance();
    Map<String, Object> newUserInfos = {
      "username": username,
      "password": password,
    };

    int rep = await db.update(
      'users',
      newUserInfos,
      where: "userId = ?",
      whereArgs: [userId],
    );

    _dbHelper.closeDb();
    return rep;
  }

  // delete the user
  Future<int> delete(int userId) async {
    final db = await _dbHelper.getDBInstance();

    int rep = await db.delete(
      'users',
      where: "userId = ?",
      whereArgs: [userId],
    );

    _dbHelper.closeDb();
    return rep;
  }

  // select the user
  Future<UserModel> select(String username, String password) async {
    final db = await _dbHelper.getDBInstance();

    List<Map<String, Object?>> userMaps = await db.query(
      'users',
      where: "username = ? and password = ?",
      whereArgs: [username, password],
    );

    _dbHelper.closeDb();
    return UserModel(
      userId: userMaps[0]["userId"] as int,
      username: userMaps[0]["username"] as String,
      password: userMaps[0]["password"] as String,
    );
  }
}
