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

  VideoModel(
      this.postId,
      this.ownerId,
      this.caption,
      this.thumbnailUrl,
      this.videoUrl,
      this.timestamp,
      this.likes,
      this.likeNumber,
      this.commentNumber);

  VideoModel copyWith({
    String? postId,
    String? ownerId,
    String? caption,
    String? thumbnailUrl,
    String? videoUrl,
    Timestamp? timestamp,
    List? likes,
    int? likeNumber,
    int? commentNumber,
  }) {
    return VideoModel(
      postId ?? this.postId,
      ownerId ?? this.ownerId,
      caption ?? this.caption,
      thumbnailUrl ?? this.thumbnailUrl,
      videoUrl ?? this.videoUrl,
      timestamp ?? this.timestamp,
      likes ?? this.likes,
      likeNumber ?? this.likeNumber,
      commentNumber ?? this.commentNumber,
    );
  }

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

  //   return result;
  // }

  factory VideoModel.fromMap(DocumentSnapshot map) {
    return VideoModel(
      map['postId'] ?? '',
      map['ownerId'] ?? '',
      map['caption'] ?? '',
      map['thumbnailUrl'] ?? '',
      map['videoUrl'] ?? '',
      map['timestamp'],
      List.from(map['likes']),
      map['likeNumber']?.toInt() ?? 0,
      map['commentNumber']?.toInt() ?? 0,
    );
  }

  // String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VideoModel(postId: $postId, ownerId: $ownerId, caption: $caption, thumbnailUrl: $thumbnailUrl, videoUrl: $videoUrl, timestamp: $timestamp, likes: $likes, likeNumber: $likeNumber, commentNumber: $commentNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is VideoModel &&
        other.postId == postId &&
        other.ownerId == ownerId &&
        other.caption == caption &&
        other.thumbnailUrl == thumbnailUrl &&
        other.videoUrl == videoUrl &&
        other.timestamp == timestamp &&
        listEquals(other.likes, likes) &&
        other.likeNumber == likeNumber &&
        other.commentNumber == commentNumber;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        ownerId.hashCode ^
        caption.hashCode ^
        thumbnailUrl.hashCode ^
        videoUrl.hashCode ^
        timestamp.hashCode ^
        likes.hashCode ^
        likeNumber.hashCode ^
        commentNumber.hashCode;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'postId': postId});
    result.addAll({'ownerId': ownerId});
    result.addAll({'caption': caption});
    result.addAll({'thumbnailUrl': thumbnailUrl});
    result.addAll({'videoUrl': videoUrl});
    result.addAll({'timestamp': timestamp});
    result.addAll({'likes': likes});
    result.addAll({'likeNumber': likeNumber});
    result.addAll({'commentNumber': commentNumber});

    return result;
  }

//   factory VideoModel.fromMap(Map<String, dynamic> map) {
//     return VideoModel(
//       map['postId'] ?? '',
//       map['ownerId'] ?? '',
//       map['caption'] ?? '',
//       map['thumbnailUrl'] ?? '',
//       map['videoUrl'] ?? '',
//       Timestamp.fromMap(map['timestamp']),
//       List.from(map['likes']),
//       map['likeNumber']?.toInt() ?? 0,
//       map['commentNumber']?.toInt() ?? 0,
//     );
//   }

//   String toJson() => json.encode(toMap());
}
