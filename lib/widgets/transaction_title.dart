import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final double amount;
  final bool isExpense;
  final String category;
  final IconData icon;

  const TransactionTile({
    super.key,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: isExpense ? Colors.red.shade100 : Colors.green.shade100,
          child: Icon(icon, color: isExpense ? Colors.red : Colors.green),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(category, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Text(
          '${isExpense ? '-' : '+'}₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isExpense ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}
