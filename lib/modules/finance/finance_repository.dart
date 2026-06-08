import 'dart:io';
import 'package:riverpod/riverpod.dart';
import 'package:oneformind/models/finance_transaction.dart';
import 'package:oneformind/models/finance_category.dart';
import 'package:oneformind/models/finance_budget.dart';
import 'package:oneformind/services/finance_service.dart';

class FinanceRepository {
  final FinanceService _financeService;

  FinanceRepository(this._financeService);

  Future<List<FinanceTransaction>> getTransactions() async {
    try {
      return await _financeService.getTransactions();
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to fetch transactions');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> addTransaction(FinanceTransaction transaction) async {
    try {
      await _financeService.addTransaction(transaction);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to add transaction');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> updateTransaction(FinanceTransaction transaction) async {
    try {
      await _financeService.updateTransaction(transaction);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to update transaction');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _financeService.deleteTransaction(id);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to delete transaction');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<List<FinanceCategory>> getCategories() async {
    try {
      return await _financeService.getCategories();
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to fetch categories');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> addCategory(FinanceCategory category) async {
    try {
      await _financeService.addCategory(category);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to add category');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> updateCategory(FinanceCategory category) async {
    try {
      await _financeService.updateCategory(category);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to update category');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _financeService.deleteCategory(id);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to delete category');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<List<FinanceBudget>> getBudgets() async {
    try {
      return await _financeService.getBudgets();
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to fetch budgets');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> addBudget(FinanceBudget budget) async {
    try {
      await _financeService.addBudget(budget);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to add budget');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> updateBudget(FinanceBudget budget) async {
    try {
      await _financeService.updateBudget(budget);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to update budget');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await _financeService.deleteBudget(id);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Unable to delete budget');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  final financeService = ref.watch(financeServiceProvider);
  return FinanceRepository(financeService);
});
