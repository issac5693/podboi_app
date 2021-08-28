import 'package:hive/hive.dart';

Box _box = Hive.box('generalBox');

Future<bool> saveNameRequest(
    {required String nameToSave, required String avatarToSave}) async {
  try {
    await _box.put('userName', nameToSave);
    await _box.put('userAvatar', avatarToSave);
    return true;
  } catch (e) {
    print(" error saving name to the box : $e");
    return false;
  }
}

String getSavedUserName() {
  return _box.get('userName') ?? 'User';
}

String getSavedUserAvatar() {
  return _box.get('userAvatar') ?? 'user';
}
