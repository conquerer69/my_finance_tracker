import 'package:flutter/material.dart';

class AddTransactionSheet extends StatefulWidget {
  final Function(String title, double amount, bool isExpense, String category, IconData icon) onSubmit;

  const AddTransactionSheet({super.key, required this.onSubmit});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isExpense = true;
  String _selectedCategory = 'Food';

  final Map<String, IconData> _categories = {
    'Food': Icons.fastfood,
    'Transport': Icons.directions_car,
    'Shopping': Icons.shopping_cart,
    'Health': Icons.local_hospital,
    'Entertainment': Icons.movie,
    'Other': Icons.category,
  };

  void _submitData() {
    final enteredTitle = _titleController.text.trim();
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (enteredTitle.isEmpty || enteredAmount <= 0) return;

    final selectedIcon = _categories[_selectedCategory] ?? Icons.category;

    widget.onSubmit(enteredTitle, enteredAmount, _isExpense, _selectedCategory, selectedIcon);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Text('Add Transaction', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Type:'),
                DropdownButton<bool>(
                  value: _isExpense,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Expense')),
                    DropdownMenuItem(value: false, child: Text('Income')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _isExpense = value ?? true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Category: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: _categories.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Row(
                        children: [
                          Icon(entry.value, size: 20),
                          const SizedBox(width: 6),
                          Text(entry.key),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitData,
              icon: const Icon(Icons.add),
              label: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
