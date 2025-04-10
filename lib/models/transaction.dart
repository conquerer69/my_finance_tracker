import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String type; // 'income' or 'expense'
  final DateTime date;
  final IconData icon; // ✅ added

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    required this.icon, // ✅ added
  });
}
