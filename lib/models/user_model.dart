import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final int post;
  final int follower;
  final int following;
  final String bio;
  final Timestamp created_on;
  final String phone_number;
  final String profile_pic;
  final String user_name;
  final String uid;
  final String email;
  final String password;
  final List searchfrom;
  final List followerList;
  final List followingList;
  UserModel({
    required this.post,
    required this.follower,
    required this.following,
    required this.bio,
    required this.created_on,
    required this.phone_number,
    required this.profile_pic,
    required this.user_name,
    required this.uid,
    required this.email,
    required this.password,
    required this.searchfrom,
    required this.followerList,
    required this.followingList,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'post': post});
    result.addAll({'follower': follower});
    result.addAll({'following': following});
    result.addAll({'bio': bio});
    result.addAll({'created_on': created_on});
    result.addAll({'phone_number': phone_number});
    result.addAll({'profile_pic': profile_pic});
    result.addAll({'user_name': user_name});
    result.addAll({'uid': uid});
    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'searchfrom': searchfrom});
    result.addAll({'followerList': followerList});
    result.addAll({'followingList': followingList});

    return result;
  }

  factory UserModel.fromMap(DocumentSnapshot  map) {
    return UserModel(
      post: map['post']?.toInt() ?? 0,
      follower: map['follower']?.toInt() ?? 0,
      following: map['following']?.toInt() ?? 0,
      bio: map['bio'] ?? '',
      created_on: map['created_on'],
      phone_number: map['phone_number'] ?? '',
      profile_pic: map['profile_pic'] ?? '',
      user_name: map['user_name'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      searchfrom: List.from(map['searchfrom']),
      followerList: List.from(map['followerList']),
      followingList: List.from(map['followingList']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    int? post,
    int? follower,
    int? following,
    String? bio,
    Timestamp? created_on,
    String? phone_number,
    String? profile_pic,
    String? user_name,
    String? uid,
    String? email,
    String? password,
    List? searchfrom,
    List? followerList,
    List? followingList,
  }) {
    return UserModel(
      post: post ?? this.post,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      bio: bio ?? this.bio,
      created_on: created_on ?? this.created_on,
      phone_number: phone_number ?? this.phone_number,
      profile_pic: profile_pic ?? this.profile_pic,
      user_name: user_name ?? this.user_name,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      searchfrom: searchfrom ?? this.searchfrom,
      followerList: followerList ?? this.followerList,
      followingList: followingList ?? this.followingList,
    );
  }
}
