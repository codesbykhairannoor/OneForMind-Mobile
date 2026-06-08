import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/models/finance_transaction.dart';

class FinanceTransactionRepository {
  List<FinanceTransaction> _transactions = [];

  Future<void> addTransaction(FinanceTransaction transaction) async {
    _transactions.add(transaction);
    await _saveTransactions();
  }

  Future<void> updateTransaction(FinanceTransaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      await _saveTransactions();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveTransactions();
  }

  List<FinanceTransaction> getTransactions() {
    return _transactions;
  }

  Future<void> _saveTransactions() async {
    // Implement saving to local storage or backend
  }

  Future<void> loadTransactions() async {
    // Implement loading from local storage or backend
    // For example, using SharedPreferences or a backend API
  }
}

final financeTransactionRepositoryProvider = Provider<FinanceTransactionRepository>((ref) {
  return FinanceTransactionRepository();
});

final financeTransactionsProvider = StateNotifierProvider<FinanceTransactionsNotifier, List<FinanceTransaction>>((ref) {
  final repository = ref.watch(financeTransactionRepositoryProvider);
  return FinanceTransactionsNotifier(repository);
});

class FinanceTransactionsNotifier extends StateNotifier<List<FinanceTransaction>> {
  final FinanceTransactionRepository _repository;

  FinanceTransactionsNotifier(this._repository) : super([]) {
    _loadTransactions();
  }

  void _loadTransactions() async {
    await _repository.loadTransactions();
    state = _repository.getTransactions();
  }

  Future<void> addTransaction(FinanceTransaction transaction) async {
    await _repository.addTransaction(transaction);
    state = _repository.getTransactions();
  }

  Future<void> updateTransaction(FinanceTransaction transaction) async {
    await _repository.updateTransaction(transaction);
    state = _repository.getTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    state = _repository.getTransactions();
  }
}
