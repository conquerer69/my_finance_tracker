import 'package:flutter/material.dart';

class IncomeExpenseCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const IncomeExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              '\₹${amount.toStringAsFixed(2)}',
              style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
