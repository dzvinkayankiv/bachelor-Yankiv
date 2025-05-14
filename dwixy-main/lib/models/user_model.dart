import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final Timestamp birthday;
  final String gender;
  final String displayName;
  final Map<String, dynamic> skinQuestionnaire;
  final Map<String, dynamic> habbitsQuestionnaire;
  final Map<String, dynamic> externalFactorsQuestionnaire;
  final bool endDateOfProductValue;
  final bool endCountOfProductValue;
  final bool newsValue;
  late final bool isQuestionnaireSkipped;
  final String? fcwToken;
  final String? imageUrl;

  UserModel({
    required this.birthday,
    required this.gender,
    required this.displayName,
    required this.skinQuestionnaire,
    required this.externalFactorsQuestionnaire,
    required this.habbitsQuestionnaire,
    this.endDateOfProductValue = false,
    this.endCountOfProductValue = false,
    this.newsValue = false,
    this.isQuestionnaireSkipped = false,
    this.fcwToken,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      birthday:
          json['birthday'] is Timestamp
              ? json['birthday'] as Timestamp
              : Timestamp.now(),
      gender:
          json['gender'] is String
              ? json['gender'] as String
              : "Стать не вказано",
      displayName:
          json['displayName'] is String
              ? json['displayName'] as String
              : "Користувач",
      skinQuestionnaire:
          (json['skinQuestionnaire'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
          ) ??
          {},
      externalFactorsQuestionnaire:
          (json['externalFactorsQuestionnaire'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
          ) ??
          {},
      habbitsQuestionnaire:
          (json['habbitsQuestionnaire'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
          ) ??
          {},
      endDateOfProductValue:
          json['endDateOfProductValue'] is bool
              ? json['endDateOfProductValue'] as bool
              : false,
      endCountOfProductValue:
          json['endCountOfProductValue'] is bool
              ? json['endCountOfProductValue'] as bool
              : false,
      newsValue: json['newsValue'] is bool ? json['newsValue'] as bool : false,
      fcwToken: json['fcwToken'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthday': birthday,
      'gender': gender,
      'displayName': displayName,
      'skinQuestionnaire': skinQuestionnaire,
      'externalFactorsQuestionnaire': externalFactorsQuestionnaire,
      'habbitsQuestionnaire': habbitsQuestionnaire,
      'endCountOfProductValue': endCountOfProductValue,
      'endDateOfProductValue': endDateOfProductValue,
      'newsValue': newsValue,
      'fcwToken': fcwToken,
      'imageUrl': imageUrl,
    };
  }

  UserModel copyWith({
    Timestamp? birthday,
    String? gender,
    String? displayName,
    Map<String, dynamic>? skinQuestionnaire,
    Map<String, dynamic>? habbitsQuestionnaire,
    Map<String, dynamic>? externalFactorsQuestionnaire,
    bool? endDateOfProductValue,
    bool? endCountOfProductValue,
    bool? newsValue,
    bool? isQuestionnaireSkipped,
    String? fcwToken,
    String? imageUrl,
  }) {
    return UserModel(
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      displayName: displayName ?? this.displayName,
      skinQuestionnaire: skinQuestionnaire ?? this.skinQuestionnaire,
      habbitsQuestionnaire: habbitsQuestionnaire ?? this.habbitsQuestionnaire,
      externalFactorsQuestionnaire: externalFactorsQuestionnaire ?? this.externalFactorsQuestionnaire,
      endDateOfProductValue: endDateOfProductValue ?? this.endDateOfProductValue,
      endCountOfProductValue: endCountOfProductValue ?? this.endCountOfProductValue,
      newsValue: newsValue ?? this.newsValue,
      isQuestionnaireSkipped: isQuestionnaireSkipped ?? this.isQuestionnaireSkipped,
      fcwToken: fcwToken ?? this.fcwToken,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
