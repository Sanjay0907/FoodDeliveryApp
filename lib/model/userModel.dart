import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String name;
  String profilePicURL;
  String userID;
  String? cloudMessagingToken;
  UserModel({
    required this.name,
    required this.profilePicURL,
    required this.userID,
    this.cloudMessagingToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePicURL': profilePicURL,
      'userID': userID,
      'cloudMessagingToken': cloudMessagingToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePicURL: map['profilePicURL'] as String,
      userID: map['userID'] as String,
      cloudMessagingToken: map['cloudMessagingToken'] != null ? map['cloudMessagingToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
