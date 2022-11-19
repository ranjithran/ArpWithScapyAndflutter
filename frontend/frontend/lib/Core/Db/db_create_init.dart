import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class DBCreateInit {
  static const _databaseName = "MyDatabase.db";

  Database init() {
    String current = p.current;
    String path = '$current\\$_databaseName';

    return sqlite3.open(path);
  }
}
