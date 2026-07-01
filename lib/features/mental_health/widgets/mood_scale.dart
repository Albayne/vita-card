import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/mood_log.dart';

class MoodScale extends StatelessWidget {
  const MoodScale({
    super.key,
    required this.selectedMood,
    required this.selectedStressors,
    required this.onMoodSelected,
    required this.onStressorsChanged,
  });

  final int? selectedMood;
  final List<String> selectedStressors;
  final ValueChanged<int> onMoodSelected;
  final ValueChanged<List<String>> onStressorsChanged;

  static const _faces = ['😞', '🙁', '😐', '🙂', '😄'];

  void _toggleStressor(String stressor) {
    final updated = [...selectedStressors];
    if (updated.contains(stressor)) {
      updated.remove(stressor);
    } else {
      updated.add(stressor);
    }
    onStressorsChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('How are you feeling?', style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            final score = i + 1;
            final selected = selectedMood == score;
            return GestureDetector(
              onTap: () => onMoodSelected(score),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.mhBlueLight : AppColors.grayLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.mhBlue : AppColors.grayBorder,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Text(_faces[i], style: const TextStyle(fontSize: 22)),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        const Text("What's on your mind?", style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MoodLog.stressorOptions.map((stressor) {
            final selected = selectedStressors.contains(stressor);
            return GestureDetector(
              onTap: () => _toggleStressor(stressor),
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.mhBlue : AppColors.grayLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppColors.mhBlue : AppColors.grayBorder,
                  ),
                ),
                child: Text(
                  stressor,
                  style: AppTextStyles.body.copyWith(
                    color: selected ? AppColors.white : AppColors.grayDark,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
