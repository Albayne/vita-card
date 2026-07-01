/// Mirrors /peer_posts/{postId} in Firestore.
/// Identified only by a 2-character anonymous code — never a token, never a name.
class PeerPost {
  PeerPost({
    required this.id,
    required this.anonymousCode,
    required this.content,
    required this.createdAt,
    this.reported = false,
  });

  final String id;
  final String anonymousCode;
  final String content;
  final DateTime createdAt;
  final bool reported;

  Map<String, dynamic> toMap() => {
        'anonymousCode': anonymousCode,
        'content': content,
        'createdAt': createdAt,
        'reported': reported,
      };

  factory PeerPost.fromMap(String id, Map<String, dynamic> map) {
    return PeerPost(
      id: id,
      anonymousCode: map['anonymousCode'] as String,
      content: map['content'] as String,
      createdAt: (map['createdAt'] as dynamic).toDate() as DateTime,
      reported: (map['reported'] as bool?) ?? false,
    );
  }
}
