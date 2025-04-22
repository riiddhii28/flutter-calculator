import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calculator/models/history_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Stream to fetch the user's history
  Stream<List<HistoryModel>> getUserHistory() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HistoryModel.fromMap(doc)).toList());
  }

  // Method to delete history item
  Future<void> deleteHistoryItem(String historyId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('history')
          .doc(historyId)
          .delete();
    } catch (e) {
      // Handle the error, maybe show a snackbar or alert
      print("Error deleting history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<HistoryModel>>(
        stream: getUserHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading history'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return const Center(child: Text('No history yet!'));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text('${item.expression} = ${item.result}'),
                subtitle: Text(
                  '${item.timestamp.toLocal()}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteHistoryItem(item.id), // Delete the history item
                ),
              );
            },
          );
        },
      ),
    );
  }
}
