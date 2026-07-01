import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/date_utils.dart';
import '../models/counsellor_slot.dart';

class SlotCard extends StatelessWidget {
  const SlotCard({super.key, required this.slot, this.onTap});

  final CounsellorSlot slot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isOnline = slot.format == 'online';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.mhBlueLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOnline ? Icons.videocam_outlined : Icons.person_outline,
                  color: AppColors.mhBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppDateUtils.formatWithTime(slot.dateTime),
                      style: AppTextStyles.headingSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${slot.durationMinutes} min · ${isOnline ? 'Online' : 'In person'} · ${slot.location}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.grayMid),
            ],
          ),
        ),
      ),
    );
  }
}
