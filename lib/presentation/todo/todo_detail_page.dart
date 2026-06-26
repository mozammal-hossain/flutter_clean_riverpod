import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_error_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo/riverpod/todo_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo/widgets/todo_detail_card_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detail page for a single Todo, reached via `/todos/:id` (e.g. from a
/// deep link or push notification payload of `{"route": "/todos/42"}`).
///
/// This page exists primarily to demonstrate path-param + `extra` routing
/// in the boilerplate. It reads the cached [todoListControllerProvider]
/// rather than firing a fresh request, so a tap from a push notification
/// that arrives while the list is already on screen is instant.
class TodoDetailPage extends ConsumerWidget {
  const TodoDetailPage({required this.id, this.extra, super.key});

  /// Path-parameter extracted from the route (e.g. `/todos/42` -> `id=42`).
  final String id;

  /// Optional payload forwarded as `GoRouter.state.extra`. Populated by
  /// push notifications (`extra_focus: "title"`) and any internal callers
  /// that want to direct attention to a specific field.
  final Map<String, Object?>? extra;

  /// When `extra["focus"]` equals this value, the title is rendered with
  /// the theme's primary accent so it stands out on cold open.
  static const _focusTitleKey = 'title';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final asyncState = ref.watch(todoListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.todoListTitle)),
      body: asyncState.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () =>
              ref.read(todoListControllerProvider.notifier).refresh(),
        ),
        data: (state) {
          final todos = switch (state) {
            TodoLoaded(:final todos) => todos,
            _ => const <Todo>[],
          };
          final match = _findTodo(todos, id);
          if (match == null) {
            return AppErrorWidget(
              message: l10n.errorNotFound,
              onRetry: () =>
                  ref.read(todoListControllerProvider.notifier).refresh(),
            );
          }
          return TodoDetailCardWidget(
            todo: match,
            highlightTitle: extra?['focus'] == _focusTitleKey,
          );
        },
      ),
    );
  }

  static Todo? _findTodo(List<Todo> todos, String id) {
    for (final todo in todos) {
      if (todo.id == id) return todo;
    }
    return null;
  }
}
