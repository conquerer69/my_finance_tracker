import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/balance_card.dart';
import '../widgets/income_expense_card.dart';
import '../widgets/transaction_title.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/expense_chart.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final income = transactionProvider.totalIncome;
    final expenses = transactionProvider.totalExpense;
    final balance = income - expenses;
    final categoryBudgets = transactionProvider.expenseByCategory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Finance Tracker'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const BudgetLimitSheet(),
              );
            },
          ),
          Row(
            children: [
              const Icon(Icons.wb_sunny),
              Switch(
                value: isDarkMode.value,
                onChanged: (value) => isDarkMode.value = value,
              ),
              const Icon(Icons.nights_stay),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $userEmail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 16),
              BalanceCard(balance: balance),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeExpenseCard(
                    title: 'Income',
                    amount: income,
                    color: Colors.green,
                  ),
                  IncomeExpenseCard(
                    title: 'Expenses',
                    amount: expenses,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const ExpenseChart(),
              const SizedBox(height: 10),

              // ⚠ Budget warnings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categoryBudgets.keys.map((category) {
                  final exceeded = transactionProvider.isBudgetExceeded(category);
                  return exceeded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '⚠ Budget exceeded for $category!',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        )
                      : const SizedBox();
                }).toList(),
              ),

              const SizedBox(height: 20),
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: transactionProvider.transactions.isEmpty
                    ? const Center(child: Text('No transactions added yet.'))
                    : ListView.builder(
                        itemCount: transactionProvider.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactionProvider.transactions[index];
                          return TransactionTile(
                            title: tx.title,
                            amount: tx.amount,
                            isExpense: tx.type == 'expense',
                            category: tx.category,
                            icon: tx.icon,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Add'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddTransactionSheet(
              onSubmit: (title, amount, isExpense, category, icon) {
                final newTransaction = Transaction(
                  id: DateTime.now().toString(),
                  title: title,
                  amount: amount,
                  category: category,
                  type: isExpense ? 'expense' : 'income',
                  date: DateTime.now(),
                  icon: icon,
                );
                transactionProvider.addTransaction(newTransaction);
              },
            ),
          );
        },
      ),
    );
  }
}

// 🧾 Budget limit input sheet
class BudgetLimitSheet extends StatefulWidget {
  const BudgetLimitSheet({super.key});

  @override
  State<BudgetLimitSheet> createState() => _BudgetLimitSheetState();
}

class _BudgetLimitSheetState extends State<BudgetLimitSheet> {
  String _category = '';
  double _limit = 0.0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Set Budget Limit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(labelText: 'Category'),
            onChanged: (value) => _category = value.trim(),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: 'Budget Amount'),
            keyboardType: TextInputType.number,
            onChanged: (value) => _limit = double.tryParse(value) ?? 0.0,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Save Limit'),
            onPressed: () {
              if (_category.isNotEmpty && _limit > 0) {
                provider.setBudgetLimit(_category, _limit);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
