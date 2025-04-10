import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final income = transactionProvider.totalIncome;
    final expenses = transactionProvider.totalExpense;
    final expenseByCategory = transactionProvider.expenseByCategory;

    final total = income + expenses;

    if (total == 0) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text("No data to show in chart."),
        ),
      );
    }

    final List<PieChartSectionData> sections = [];

    sections.add(
      PieChartSectionData(
        value: income,
        title: 'Income\n${(income / total * 100).toStringAsFixed(1)}%',
        color: Colors.green,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );

    expenseByCategory.forEach((category, amount) {
      final isOverBudget = transactionProvider.isBudgetExceeded(category);

      sections.add(
        PieChartSectionData(
          value: amount,
          title: '$category\n${(amount / total * 100).toStringAsFixed(1)}%',
          color: isOverBudget ? Colors.red.shade700 : _getCategoryColor(category),
          radius: 60,
          titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 200,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: sections,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'shopping':
        return Colors.purple;
      case 'transport':
        return Colors.blueGrey;
      case 'entertainment':
        return Colors.redAccent;
      default:
        return Colors.blue;
    }
  }
}
