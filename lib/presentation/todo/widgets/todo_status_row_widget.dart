import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';

/// Completed / pending status row for a todo detail card.
class TodoStatusRowWidget extends StatelessWidget {
  const TodoStatusRowWidget({required this.completed, super.key});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          size: AppSize.iconMd,
          color: completed ? context.colors.primary : context.colors.outline,
        ),
        SizedBox(width: AppSize.spaceSm),
        Text(
          completed ? 'Completed' : 'Pending',
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
