import 'dart:convert';
import 'dart:io';

void main() {
  final Map<String, Object?> schema =
      (jsonDecode(
                File(
                  'artifacts/schemas/condition_catalog.schema.json',
                ).readAsStringSync(),
              )
              as Map)
          .cast<String, Object?>();
  final List<String> catalogFields =
      (schema['required_catalog_fields']! as List<Object?>).cast<String>();
  final List<String> conditionFields =
      (schema['required_condition_fields']! as List<Object?>).cast<String>();
  final Set<String> statuses = (schema['allowed_statuses']! as List<Object?>)
      .cast<String>()
      .toSet();
  final List<File> files =
      Directory('artifacts/conditions')
          .listSync()
          .whereType<File>()
          .where((File file) => file.path.endsWith('.json'))
          .toList()
        ..sort((File a, File b) => a.path.compareTo(b.path));
  final Set<String> catalogIds = <String>{};
  final Set<String> conditionIds = <String>{};
  int conditionCount = 0;
  for (final File file in files) {
    final Map<String, Object?> catalog =
        (jsonDecode(file.readAsStringSync()) as Map).cast<String, Object?>();
    for (final String field in catalogFields) {
      _expect(catalog.containsKey(field), '${file.path}: thiếu $field');
    }
    _expect(
      catalog['schema_version'] == schema['schema_version'],
      '${file.path}: schema_version không được hỗ trợ',
    );
    final String catalogId = catalog['catalog_id']! as String;
    _expect(catalogIds.add(catalogId), 'Trùng catalog_id $catalogId');
    final List<Object?> conditions = catalog['conditions']! as List<Object?>;
    _expect(conditions.isNotEmpty, '${file.path}: catalog rỗng');
    for (final Object? raw in conditions) {
      final Map<String, Object?> condition = (raw! as Map)
          .cast<String, Object?>();
      for (final String field in conditionFields) {
        _expect(
          condition.containsKey(field),
          '${file.path}: điều kiện thiếu $field',
        );
      }
      final String id = condition['id']! as String;
      _expect(conditionIds.add(id), 'Trùng condition id $id');
      _expect(
        statuses.contains(condition['status']),
        '$id: status ${condition['status']} không hợp lệ',
      );
      for (final String field in conditionFields) {
        _expect(
          condition[field] is String &&
              (condition[field]! as String).isNotEmpty,
          '$id: $field phải là chuỗi không rỗng',
        );
      }
      conditionCount += 1;
    }
  }
  print('Condition catalog verification passed.');
  print('Catalogs: ${files.length}');
  print('Conditions: $conditionCount');
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
