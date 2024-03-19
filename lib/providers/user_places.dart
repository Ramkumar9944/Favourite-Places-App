import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  Future<void> loadPlace() async {
    final db = await getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map((item) => Place(
              id: item['id'] as String,
              title: item['title'] as String,
              image: File(item['image'] as String),
              location: PlaceLocation(
                latitude: item['lat'] as double,
                longitude: item['lng'] as double,
                address: item['address'] as String,
              ),
            ))
        .toList();
    state = places;
  }

  void addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.image.path);
    final sourceFile = File(place.image.path);

    // Check if the source file exists before attempting to copy
    if (await sourceFile.exists()) {
      final copiedImage = await sourceFile.copy('${appDir.path}/$fileName');
      final newPlace = Place(
        title: place.title,
        image: File(copiedImage.path),
        location: place.location,
      );
      final db = await getDatabase();
      db.insert(
        'user_places',
        {
          'id': newPlace.id,
          'title': newPlace.title,
          'image': copiedImage.path,
          'lat': newPlace.location.latitude,
          'lng': newPlace.location.longitude,
          'address': newPlace.location.address,
        },
      );
      state = [...state, newPlace];
    } else {
      print('Source file does not exist.');
    }
  }
}

final UserPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
