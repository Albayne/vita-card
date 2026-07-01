import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/info_box.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/mh_provider.dart';
import '../widgets/mood_scale.dart';

class MhMoodScreen extends ConsumerStatefulWidget {
  const MhMoodScreen({super.key});

  @override
  ConsumerState<MhMoodScreen> createState() => _MhMoodScreenState();
}

class _MhMoodScreenState extends ConsumerState<MhMoodScreen> {
  int? _mood;
  List<String> _stressors = [];
  bool _saving = false;

  Future<void> _save() async {
    final mood = _mood;
    if (mood == null) return;
    setState(() => _saving = true);
    await ref.read(mhControllerProvider).addMoodLog(mood, _stressors);
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log your mood')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const InfoBox(
              message: 'This stays only on your device. It is never sent anywhere.',
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 20),
            MoodScale(
              selectedMood: _mood,
              selectedStressors: _stressors,
              onMoodSelected: (mood) => setState(() => _mood = mood),
              onStressorsChanged: (stressors) => setState(() => _stressors = stressors),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save',
              onPressed: _mood == null || _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
