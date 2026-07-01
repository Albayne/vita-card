import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/date_utils.dart';
import '../providers/dashboard_provider.dart';

class RemindersFeed extends StatelessWidget {
  const RemindersFeed({super.key, required this.items});

  final List<ReminderItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No reminders right now.', style: AppTextStyles.caption),
      );
    }

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined,
                      color: AppColors.teal, semanticLabel: 'Reminder'),
                  title: Text(item.title, style: AppTextStyles.headingSmall),
                  subtitle: Text(
                    '${item.subtitle} · ${AppDateUtils.formatShort(item.dueDate)}',
                    style: AppTextStyles.caption,
                  ),
                  onTap: () => context.push(item.route),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
