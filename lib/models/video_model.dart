import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class VideoModel {
  final String postId;
  final String ownerId;
  final String caption;
  final String thumbnailUrl;
  final String videoUrl;
  final Timestamp timestamp;
  final List likes;
  final int likeNumber;
  final int commentNumber;
  final int downloadNumber;
  VideoModel({
    required this.postId,
    required this.ownerId,
    required this.caption,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.timestamp,
    required this.likes,
    required this.likeNumber,
    required this.commentNumber,
    required this.downloadNumber,
  });

  // Map<String, dynamic> toMap() {
  //   final result = <String, dynamic>{};

  //   result.addAll({'postId': postId});
  //   result.addAll({'ownerId': ownerId});
  //   result.addAll({'caption': caption});
  //   result.addAll({'thumbnailUrl': thumbnailUrl});
  //   result.addAll({'videoUrl': videoUrl});
  //   result.addAll({'timestamp': timestamp.toMap()});
  //   result.addAll({'likes': likes});
  //   result.addAll({'likeNumber': likeNumber});
  //   result.addAll({'commentNumber': commentNumber});
  //   result.addAll({'downloadNumber': downloadNumber});

  //   return result;
  // }

  factory VideoModel.fromMap(DocumentSnapshot map) {
    return VideoModel(
      postId: map['postId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      caption: map['caption'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      timestamp: map['timestamp'],
      likes: List.from(map['likes']),
      likeNumber: map['likeNumber']?.toInt() ?? 0,
      commentNumber: map['commentNumber']?.toInt() ?? 0,
      downloadNumber: map['downloadNumber']?.toInt() ?? 0,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory VideoModel.fromJson(String source) => VideoModel.fromMap(json.decode(source));
}
