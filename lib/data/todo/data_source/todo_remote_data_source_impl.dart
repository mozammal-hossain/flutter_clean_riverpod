import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/network/network_guard.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/api/todo_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/data_source/todo_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';

/// Real network-backed implementation that talks to DummyJSON through the
/// generated `TodoApi` client.
///
/// DummyJSON simulates writes — `add` / `update` / `delete` echo a response
/// but never mutate server state. Callers must update local UI optimistically
/// rather than re-fetching the list after a mutation.
class TodoRemoteDataSourceImpl implements TodoDataSource {
  TodoRemoteDataSourceImpl(this._api);

  /// Fallback until the authenticated user id is wired from auth.
  static const defaultUserId = 1;

  final TodoApi _api;

  @override
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken}) =>
      guard('TodoRemoteDataSourceImpl.fetchAll', () async {
        final response = await _api.getTodos(cancelToken: cancelToken);
        return response.todos;
      });

  @override
  Future<TodoDto> create(String title, {CancelToken? cancelToken}) => guard(
    'TodoRemoteDataSourceImpl.create',
    () => _api.createTodo(
      CreateTodoRequestDto(todo: title, userId: defaultUserId),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  }) => guard(
    'TodoRemoteDataSourceImpl.toggle',
    () => _api.updateTodo(
      id,
      UpdateTodoRequestDto(completed: completed),
      cancelToken: cancelToken,
    ),
  );

  @override
  Future<void> delete(String id, {CancelToken? cancelToken}) =>
      guard('TodoRemoteDataSourceImpl.delete', () async {
        await _api.deleteTodo(id, cancelToken: cancelToken);
      });
}
