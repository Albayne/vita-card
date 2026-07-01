import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/date_utils.dart';
import '../models/peer_post.dart';

class PeerPostCard extends StatelessWidget {
  const PeerPostCard({super.key, required this.post, required this.onReport});

  final PeerPost post;
  final VoidCallback onReport;

  Future<void> _confirmReport(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report this post?'),
        content: const Text('This will hide the post pending review.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Report')),
        ],
      ),
    );
    if (confirmed == true) onReport();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.quittrrAmberLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(post.anonymousCode, style: AppTextStyles.label),
                ),
                IconButton(
                  icon: const Icon(Icons.flag_outlined, size: 20, color: AppColors.grayMid, semanticLabel: 'Report'),
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  onPressed: () => _confirmReport(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content, style: AppTextStyles.body),
            const SizedBox(height: 6),
            Text(AppDateUtils.formatShort(post.createdAt), style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
