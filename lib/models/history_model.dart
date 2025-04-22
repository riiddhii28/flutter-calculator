import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String id;
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryModel({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  factory HistoryModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return HistoryModel(
      id: doc.id,
      expression: data['expression'] ?? '',
      result: data['result'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
