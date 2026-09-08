import 'package:shared_preferences/shared_preferences.dart';

const String defaultSaveKey = 'reality_cultivation.save.v1';

abstract interface class SaveRepository {
  Future<String?> readLatest();
  Future<void> writeLatest(String save);
  Future<void> deleteLatest();
}

class SharedPreferencesSaveRepository implements SaveRepository {
  SharedPreferencesSaveRepository({
    SharedPreferencesAsync? preferences,
    this.key = defaultSaveKey,
  }) : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;
  final String key;

  @override
  Future<String?> readLatest() => _preferences.getString(key);

  @override
  Future<void> writeLatest(String save) => _preferences.setString(key, save);

  @override
  Future<void> deleteLatest() => _preferences.remove(key);
}

class MemorySaveRepository implements SaveRepository {
  String? value;

  @override
  Future<String?> readLatest() async => value;

  @override
  Future<void> writeLatest(String save) async {
    value = save;
  }

  @override
  Future<void> deleteLatest() async {
    value = null;
  }
}
