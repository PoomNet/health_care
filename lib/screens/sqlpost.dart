import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String profileTable = "post";
final String idColumn = "id";
final String causeColumn = "cause";
final String symptomColumn = "symptom";
final String categoryColumn = "category";
final String describeColumn = "describe";
final String userColumn = "user";
final String imageColumn = "image";

class ProfileItem {
  int id;
  String cause;
  String symptom;
  String category;
  String describe;
  String user;
  String image;

  ProfileItem();

  ProfileItem.formMap(Map<String, dynamic> map) {
    this.id = map[idColumn];
    this.cause = map[causeColumn];
    this.symptom = map[symptomColumn];
    this.category = map[categoryColumn];
    this.describe = map[describeColumn];
    this.user = map[userColumn];
    this.image = map[imageColumn];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      causeColumn: cause,
      symptomColumn: symptom,
      categoryColumn: category,
      describeColumn: describe,
      userColumn: user,
      imageColumn: image,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'id: ${this.id}, cause:  ${this.cause}, symptom:  ${this.symptom}, category:  ${this.category}, describe:  ${this.describe}, user:  ${this.user}, image:  ${this.image}';
  }
}

class DataAccess {
  Database db;
  String path = "user.db";

  Future open() async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table $profileTable ( 
    $idColumn integer primary key autoincrement, 
    $causeColumn text not null,
    $symptomColumn text not null,
    $categoryColumn text not null,
    $describeColumn text not null,
    $userColumn text not null,
    $imageColumn text not null)
  ''');
    });
  }

  Future<ProfileItem> insertUser(ProfileItem item) async {
    item.id = await db.insert(profileTable, item.toMap());
    return item;
  }

  Future<ProfileItem> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(profileTable,
        columns: [
          idColumn,
          causeColumn,
          symptomColumn,
          categoryColumn,
          describeColumn,
          userColumn,
          imageColumn
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    maps.length > 0 ? new ProfileItem.formMap(maps.first) : null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(profileTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> update(ProfileItem todo) async {
    return await db.update(profileTable, todo.toMap(),
        where: '$idColumn = ?', whereArgs: [todo.id]);
  }

  Future<List<ProfileItem>> getAllUser() async {
    await this.open();
    var res = await db.query(profileTable, columns: [
      idColumn,
      causeColumn,
      symptomColumn,
      categoryColumn,
      describeColumn,
      userColumn,
      imageColumn
    ]);
    List<ProfileItem> userList =
        res.isNotEmpty ? res.map((c) => ProfileItem.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();
}
