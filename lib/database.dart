

import 'package:mysql1/mysql1.dart';

class Database {
  static String host = '34.124.120.142',
                user = 'root',
                password = 'Brushy98',
                db = 'PocketKitchen';
  static int port = 3306;

  Database();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db
    );
    return await MySqlConnection.connect(settings);
  }
}
