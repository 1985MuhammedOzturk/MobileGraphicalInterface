import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TodoDaoWeb {
  static final TodoDaoWeb instance = TodoDaoWeb._init();
  SharedPreferences? _prefs;

  TodoDaoWeb._init();

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> insertTodoItem(String title) async {
    await _initPrefs();
    final items = await fetchTodoItems();
    items.add({'title': title});
    await _prefs!.setString('todo_items', jsonEncode(items));
  }

  Future<List<Map<String, dynamic>>> fetchTodoItems() async {
    await _initPrefs();
    final jsonString = _prefs!.getString('todo_items');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return List<Map<String, dynamic>>.from(jsonList);
    }
    return [];
  }

  Future<void> deleteTodoItem(int index) async {
    await _initPrefs();
    final items = await fetchTodoItems();
    items.removeAt(index);
    await _prefs!.setString('todo_items', jsonEncode(items));
  }
}
