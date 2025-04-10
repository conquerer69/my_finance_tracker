import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];
  final Map<String, double> _categoryBudgets = {};

  List<Transaction> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((tx) => tx.type == 'income')
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get totalExpense => _transactions
      .where((tx) => tx.type == 'expense')
      .fold(0.0, (sum, tx) => sum + tx.amount);

  Map<String, double> get expenseByCategory {
    final Map<String, double> data = {};
    for (var tx in _transactions) {
      if (tx.type == 'expense') {
        data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
      }
    }
    return data;
  }

  void addTransaction(Transaction tx) {
    _transactions.add(tx);
    notifyListeners();
  }

  void setBudgetLimit(String category, double limit) {
    _categoryBudgets[category] = limit;
    notifyListeners();
  }

  double getBudgetLimit(String category) {
    return _categoryBudgets[category] ?? 0.0;
  }

  bool isBudgetExceeded(String category) {
    final spent = expenseByCategory[category] ?? 0;
    final limit = _categoryBudgets[category] ?? double.infinity;
    return spent > limit;
  }

  Map<String, double> get budgetLimits => _categoryBudgets; // ✅ Needed for HomeScreen
}
