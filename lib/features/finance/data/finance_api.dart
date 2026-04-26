import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'finance_api.g.dart';

@riverpod
FinanceApi financeApi(FinanceApiRef ref) {
  return FinanceApi(ref.watch(dioProvider));
}

class FinanceApi {
  final Dio _dio;

  FinanceApi(this._dio);

  Future<Response> getFinanceSummary() async {
    return _dio.get('/finance');
  }

  Future<Response> createTransaction({
    required int categoryId,
    required double amount,
    required String type, // expense | income
    required String date,
    String? notes,
  }) async {
    return _dio.post(
      '/finance/transaction',
      data: {
        'finance_category_id': categoryId,
        'amount': amount,
        'type': type,
        'date': date,
        'notes': notes,
      },
    );
  }
}
