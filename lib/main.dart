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
  TodoItem? _selectedItem;

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

  Future<void> _removeItem(TodoItem item) async {
    await myDAO.deleteItem(item);
    _loadItems(); // Refresh list
    setState(() {
      _selectedItem = null;
    });
  }

  void _showDetails(TodoItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  void _closeDetails() {
    setState(() {
      _selectedItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

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
              child: isPortrait
                  ? _selectedItem == null
                  ? _items.isEmpty
                  ? const Center(child: Text("There are no items in the list."))
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showDetails(_items[index]),
                    child: ListTile(
                      title: Center(
                        child: Text("${index + 1}: ${_items[index].item} - Quantity: ${_items[index].quantity}"),
                      ),
                    ),
                  );
                },
              )
                  : DetailsPage(
                item: _selectedItem!,
                onDelete: _removeItem,
                onClose: _closeDetails,
              )
                  : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showDetails(_items[index]),
                          child: ListTile(
                            title: Center(
                              child: Text("${index + 1}: ${_items[index].item} - Quantity: ${_items[index].quantity}"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _selectedItem == null
                        ? const Center(child: Text("Select an item to view details"))
                        : SingleChildScrollView(
                      child: DetailsPage(
                        item: _selectedItem!,
                        onDelete: _removeItem,
                        onClose: _closeDetails,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final TodoItem item;
  final Function(TodoItem) onDelete;
  final Function() onClose;

  const DetailsPage({
    Key? key,
    required this.item,
    required this.onDelete,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Item: ${item.item}", style: const TextStyle(fontSize: 24)),
          Text("Quantity: ${item.quantity}", style: const TextStyle(fontSize: 20)),
          Text("ID: ${item.id}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => onDelete(item),
            child: const Text("Delete"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onClose,
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}