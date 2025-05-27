// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongoappv2/MongoDB/constant.dart';
import 'package:mongoappv2/Models/userData.dart';

class MongoDatabase {
  static late Db db;
  //static late DbCollection userCollection;
  //static late DbCollection audiCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create(MONGO_CONN_URL);
      await db.open();
      inspect(db);
      // userCollection = db.collection(USER_COLLECTION);
      // audiCollection = db.collection(Auditorium_Canteen);
      log('MongoDB connection successful', name: 'MongoDatabase');
    } catch (e) {
      log('Error connecting to MongoDB: $e', name: 'MongoDatabase');
    }
  }

  static Future<List<UserData>> getUserData(String collectionName) async {
    try {
      DbCollection collection = db.collection(collectionName);
      // Perform a query to get user data from MongoDB
      final List<Map<String, dynamic>> results =
          await collection.find().toList();

      // Convert the query results into UserData objects
      final List<UserData> userList = results.map((userDataMap) {
        final String name = userDataMap['name'].toString();
        final String imgUrl = userDataMap['imgUrl'].toString();
        final String description = userDataMap['description'].toString();
        final int price = userDataMap['price'] as int;

        if (name == 'null') {
          print('Warning: Found null title in MongoDB data.');
        }

        if (imgUrl == 'null') {
          print('Warning: Found null photo URL in MongoDB data.');
        }
        if (description == 'null') {
          print('Warning: Found null description in MongoDB data.');
        }
        if (price == 0) {
          print('Warning: Found null price in MongoDB data.');
        }

        return UserData(name, imgUrl, description, price, collectionName);
      }).toList();

      return userList;
      // ignore: duplicate_ignore
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user data from MongoDB: $e');
      // Handle the error appropriately, e.g., return an empty list or re-throw the exception.
      return [];
    }
  }
}


//
// static var db , userCollection;
// static connect() async {
//   db = await Db.create(MONGO_CONN_URL);
//   await db.open();
//   inspect(db);
//   userCollection = db.collection(USER_COLLECTION);
// }