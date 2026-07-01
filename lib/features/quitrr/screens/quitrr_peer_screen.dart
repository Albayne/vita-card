import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/privacy_notice_banner.dart';
import '../providers/quitrr_provider.dart';
import '../widgets/peer_post_card.dart';

const _peerPrivacyNotice = 'Posts are anonymous and screened by you and the '
    'community. VitaCard never links a post to your identity.';

class QuitrrPeerScreen extends ConsumerStatefulWidget {
  const QuitrrPeerScreen({super.key});

  @override
  ConsumerState<QuitrrPeerScreen> createState() => _QuitrrPeerScreenState();
}

class _QuitrrPeerScreenState extends ConsumerState<QuitrrPeerScreen> {
  final _controller = TextEditingController();
  String? _rejectionMessage;
  bool _posting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    setState(() {
      _posting = true;
      _rejectionMessage = null;
    });
    final success = await ref.read(quitrrControllerProvider).submitPost(text);
    setState(() => _posting = false);
    if (success) {
      _controller.clear();
    } else {
      setState(() => _rejectionMessage = "That post couldn't be shared. Please rephrase it.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Peer support')),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: PrivacyNoticeBanner(message: _peerPrivacyNotice),
            ),
            Expanded(
              child: postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const Center(
                      child: Text('No posts yet. Be the first to share.', style: AppTextStyles.body),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PeerPostCard(
                          post: post,
                          onReport: () => ref.read(quitrrControllerProvider).reportPost(post.id),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const Center(
                  child: Text('Could not load posts.', style: AppTextStyles.body),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_rejectionMessage != null) ...[
                      Text(_rejectionMessage!, style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                    ],
                    TextField(
                      controller: _controller,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Share something with the community…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(label: 'Post', onPressed: _posting ? null : _post),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
