import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'todo_dao.dart';
import 'todo_dao_web.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  Future<void> _loadTodoItems() async {
    List<Map<String, dynamic>> items;
    if (kIsWeb) {
      items = await TodoDaoWeb.instance.fetchTodoItems();
    } else {
      items = await TodoDao.instance.fetchTodoItems();
    }
    setState(() {
      _todoItems = items;
    });
  }

  Future<void> _addItem() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      if (kIsWeb) {
        await TodoDaoWeb.instance.insertTodoItem(text);
      } else {
        await TodoDao.instance.insertTodoItem({'title': text});
      }
      _controller.clear();
      _loadTodoItems();
    }
  }

  Future<void> _deleteItem(int index) async {
    if (kIsWeb) {
      await TodoDaoWeb.instance.deleteTodoItem(index);
    } else {
      await TodoDao.instance.deleteTodoItem(_todoItems[index]['id']);
    }
    _loadTodoItems();
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _todoItems[index];
    return ListTile(
      title: Text('Row number: $index'),
      subtitle: Text(item['title']),
      onLongPress: () => _showDeleteDialog(index),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteItem(index);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a todo item',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add'),
            ),
            Expanded(
              child: _todoItems.isEmpty
                  ? Center(child: Text('There are no items in the list'))
                  : ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: _buildItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
