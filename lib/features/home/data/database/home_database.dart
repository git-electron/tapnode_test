import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/model/document_model.dart';

part 'home_database.g.dart';

@DriftDatabase(tables: [Documents])
class HomeDatabase extends _$HomeDatabase {
  HomeDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'signica_home'));

  @override
  int get schemaVersion => 1;
}

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get filePath => text()();

  TextColumn get type => text().withDefault(const Constant('PDF'))();

  BoolColumn get isSigned =>
      boolean().named('is_signed').withDefault(const Constant(false))();

  TextColumn get source => textEnum<DocumentImportSource>()();

  TextColumn get pagePaths => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  TextColumn get previewImagePaths => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  DateTimeColumn get createdAt => dateTime().named('created_at')();
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String sql) {
    final decodedValue = jsonDecode(sql);
    if (decodedValue is! List) return const [];

    return decodedValue.whereType<String>().toList(growable: false);
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}
