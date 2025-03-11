import 'package:flutter/material.dart';
import 'database.dart';
import 'todo_item.dart';
import 'todo_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: ShoppingListPage(database: database),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  final AppDatabase database;

  const ShoppingListPage({Key? key, required this.database}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late TodoDao myDAO;
  final List<TodoItem> _items = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    myDAO = widget.database.todoDao;
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await myDAO.getAllItems();
    setState(() {
      _items.clear();
      _items.addAll(items);
    });
  }

  Future<void> _addItem() async {
    String item = _itemController.text.trim();
    String quantity = _quantityController.text.trim();
    if (item.isNotEmpty && quantity.isNotEmpty) {
      final newItem = TodoItem(item: item, quantity: quantity);
      await myDAO.insertItem(newItem);
      _itemController.clear();
      _quantityController.clear();
      _loadItems(); // Reload items
    }
  }

  Future<void> _removeItem(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await myDAO.deleteItem(_items[index]);
                _loadItems(); // Refresh list
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        backgroundColor: Colors.purple[200],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(hintText: "Enter item", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(hintText: "Enter quantity", border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text("ADD"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center( // Centers the content
                child: _items.isEmpty
                    ? const Text("There are no items in the list.")
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers list vertically
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true, // Prevents extra scrolling issues
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () => _removeItem(index),
                            child: ListTile(
                              title: Center( // Center the text in ListTile
                                child: Text("${index + 1}: ${_items[index].item} - Quantity: ${_items[index].quantity}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}