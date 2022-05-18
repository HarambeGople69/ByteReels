import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String comment;
  final String commentId;
  final String ownerId;
  final Timestamp timestamp;

  CommentModel(
    this.comment,
    this.commentId,
    this.ownerId,
    this.timestamp,
  );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'comment': comment});
    result.addAll({'commentId': commentId});
    result.addAll({'ownerId': ownerId});
    result.addAll({'timestamp': timestamp});
  
    return result;
  }

  factory CommentModel.fromMap(DocumentSnapshot map) {
    return CommentModel(
      map['comment'] ?? '',
      map['commentId'] ?? '',
      map['ownerId'] ?? '',
      map['timestamp']??"",
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source));

  CommentModel copyWith({
    String? comment,
    String? commentId,
    String? ownerId,
    Timestamp? timestamp,
  }) {
    return CommentModel(
      comment ?? this.comment,
      commentId ?? this.commentId,
      ownerId ?? this.ownerId,
      timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CommentModel &&
      other.comment == comment &&
      other.commentId == commentId &&
      other.ownerId == ownerId &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return comment.hashCode ^
      commentId.hashCode ^
      ownerId.hashCode ^
      timestamp.hashCode;
  }
}
