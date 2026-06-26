import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';

/// Contract every Todo data source must satisfy. The mock implementation
/// in `TodoMockDataSource` and the Retrofit-backed
/// `TodoRemoteDataSourceImpl` both satisfy this interface so the repository
/// can swap them via a single provider override.
abstract interface class TodoDataSource {
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken});
  Future<TodoDto> create(String title, {CancelToken? cancelToken});
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  });
  Future<void> delete(String id, {CancelToken? cancelToken});
}
