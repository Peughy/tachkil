import 'package:tachkil/src/models/user_model.dart';
import 'package:tachkil/src/utils/database_helper.dart';

class UsersQueries {
  DatabaseHelper dbHelper = DatabaseHelper();

  // insert new user
  Future<int> insert(UserModel userModel) async {
    final db = await dbHelper.getDBInstance();

    int rep = await db.insert('users', userModel.toMap());
    return rep;
  }

  // update the user
  Future<int> update(int userId, String username, String password) async {
    final db = await dbHelper.getDBInstance();
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

    return rep;
  }

  // delete the user
  Future<int> delete(int userId) async {
    final db = await dbHelper.getDBInstance();

    int rep = await db.delete(
      'users',
      where: "userId = ?",
      whereArgs: [userId],
    );
    return rep;
  }

  // select the user
  Future<UserModel> select(int userId) async {
    final db = await dbHelper.getDBInstance();

    List<Map<String, Object?>> userMaps = await db.query(
      'users',
      where: "userId = ?",
      whereArgs: [userId],
    );
    return UserModel(
      userId: userMaps[0]["userId"] as int,
      username: userMaps[0]["username"] as String,
      password: userMaps[0]["password"] as String,
    );
  }
}
