import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageInterceptor extends Interceptor {
  final BuildContext context;

  LanguageInterceptor(this.context);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final languageCode = context.locale.languageCode;
    options.headers['Accept-Language'] = languageCode;
    super.onRequest(options, handler);
  }
}
