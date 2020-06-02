import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_city/model/ModelEvent.dart';
import 'package:sqflite/sqflite.dart';

class DBprovider {
  DBprovider._();

  static final DBprovider db = DBprovider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db){},
    onCreate: (Database db, int version) async{
      await db.execute("CREATE TABLE events ("
            "id INTEGER,  "
            "eventName TEXT,"
            "eventDescription TEXT,"
            "latitude REAL,"
            "longitude REAL,"
            "event_date TEXT,"
            "dateChange TEXT,"
            "status_id INT,"
            "statusName TEXT,"
            "category_id INT,"
            "categoryName TEXT,"
            "user_id INT,"
            "email TEXT,"
            "visibilityForUser INT"
            ")");
    });
  }

  _insertEvent(ModelEvent event) async {
    try{
      final db = await database;
        int insertRaw = await db.rawInsert(
          "INSERT Into events (id, eventName, eventDescription, latitude, longitude, event_date, dateChange, status_id, statusName, category_id, categoryName, user_id, email, visibilityForUser)"
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [event.id, event.eventName, event.eventDescription, event.latitude, event.longitude, event.event_date, event.dateChange, event.status_id, event.statusName, event.category_id, event.categoryName, event.user_id, event.email, event.visibilityForUser]
        ); 
        print("INSERT: " + insertRaw.toString());
    } catch (Exception){
      
    }
  }

  _updateEvent(ModelEvent event) async {
    try{
      final db = await database;
      int updatedRaw = await db.rawUpdate(
          "UPDATE events SET eventName=?, eventDescription=?, latitude=?, longitude=?, event_date=?, dateChange=?, status_id=?, statusName=?, category_id=?, categoryName=?, user_id=?, email=?, visibilityForUser=?"
          "WHERE id = ?",
          [event.eventName, event.eventDescription, event.latitude, event.longitude, event.event_date, event.dateChange, event.status_id, event.statusName, event.category_id, event.categoryName, event.user_id, event.email, event.visibilityForUser, event.id]
        ); 
      print("UPDATED: " + updatedRaw.toString()); 
    } catch (Exception) {

    }
  }

  _deleteEvent(int id) async {
    try{
      final db= await database;
      int deleteRaw = await db.rawDelete("DELETE FROM events WHERE id = ?", [id]);
      print("DELETE: " + deleteRaw.toString());
    } catch (Exception) {

    }
  }

  Future<ModelEvent> selectEvent(int id) async {
    final db = await database;
    var res = await db.query("events", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {      
      return ModelEvent.fromJson(res.first);
    } else {
      return null;
    }
  }

  setEvents(List<ModelEvent> events){
    try{
      for (ModelEvent event in events) {
        print("EVENT_VISIBILITY_USER: " + event.toString());        
          Future future = selectEvent(event.id);
          future.then((value){
            ModelEvent selectEvent = value;
            print("SELECTED EVENT: " + selectEvent.toString());
            if (event.visibilityForUser == 1){ 
              if (selectEvent == null) {
              _insertEvent(event);
              } else {
                _updateEvent(event);
              } 
            } else {
              print("ИХ НУЖНО УДАЛИТЬ!!! " + event.visibilityForUser.toString());
            _deleteEvent(event.id);
            } 
          });  
      }
    } catch (Exception) {

    }
  }

  Future<List<ModelEvent>> selectEvents(String categoryName, String statusName) async {
    final db = await database;
    List<ModelEvent> events = new List<ModelEvent>();
    var res = await db.rawQuery("SELECT * FROM events");
    if ((categoryName == "Все") && (statusName == "Все")) res = await db.rawQuery("SELECT * FROM events");
    else if ((categoryName == "Все") && (statusName != "Все")) res = await db.rawQuery("SELECT * FROM events WHERE statusName = ?", [statusName]);
    else if ((categoryName != "Все") && (statusName == "Все")) res = await db.rawQuery("SELECT * FROM events WHERE categoryName = ?", [categoryName]);
    else res = await db.rawQuery("SELECT * FROM events WHERE categoryName = ? AND statusName = ?", [categoryName, statusName]);
    if (res.isNotEmpty) {
      events = res.map((e) => ModelEvent.fromJson(e)).toList(); 
    }
    return events; 
  }  
}