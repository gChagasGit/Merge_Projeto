// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:async';

import 'package:mysql1/mysql1.dart';

class MySql {
  MySql();

  Future<MySqlConnection> BancoDadosConfig() async {
    // Open a connection (testdb should already exist)
    MySqlConnection conn;
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'pdv_projeto_teste',
        password: 'admin'));
    return conn;
  }
  /*
  // Create a table
  await conn.query(
      'CREATE TABLE users (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255), email varchar(255), age int)');

  // Insert some data
  var result = await conn.query(
      'insert into users (name, email, age) values (?, ?, ?)',
      ['Bob', 'bob@bob.com', 25]);
  print('Inserted row id=${result.insertId}');

  // Query the database using a parameterized query
  var results = await conn.query(
      'select name, email, age from users where id = ?', [result.insertId]);
  for (var row in results) {
    print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  }

  // Update some data
  await conn.query('update users set age=? where name=?', [26, 'Bob']);

  // Query again database using a parameterized query
  var results2 = await conn.query(
      'select name, email, age from users where id = ?', [result.insertId]);
  for (var row in results2) {
    print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  }

  // Finally, close the connection
  await conn.close();
  */
}
