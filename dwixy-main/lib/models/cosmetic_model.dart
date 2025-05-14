import 'package:cloud_firestore/cloud_firestore.dart';

class CosmeticModel {
  late final String id;
  final String type;
  final String name;
  final String size;
  final Timestamp expirationDate;
  final Timestamp openDate;
  final num remains;
  final String periodOfUse;
  final String imageUrl;

  CosmeticModel({
    required this.id,
    required this.type,
    required this.name,
    required this.size,
    required this.expirationDate,
    required this.openDate,
    required this.remains,
    required this.periodOfUse,
    required this.imageUrl,
  });

  factory CosmeticModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CosmeticModel(
      id: doc.id,
      type: data['type'] ?? '',
      name: data['name'] ?? '',
      size: data['size'] ?? '',
      expirationDate: data['expirationDate'] ?? Timestamp.now(),
      openDate: data['openDate'] ?? Timestamp.now(),
      remains: data['remains'] ?? 0,
      periodOfUse: data['periodOfUse'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'size': size,
      'expirationDate': expirationDate,
      'openDate': openDate,
      'remains': remains,
      'periodOfUse': periodOfUse,
      'imageUrl': imageUrl,
    };
  }

  CosmeticModel copyWith({
    String? id,
    String? name,
    String? type,
    String? size,
    String? imageUrl,
    Timestamp? expirationDate,
    Timestamp? openDate,
    num? remains,
    String? periodOfUse,
  }) {
    return CosmeticModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      imageUrl: imageUrl ?? this.imageUrl,
      expirationDate: expirationDate ?? this.expirationDate,
      openDate: openDate ?? this.openDate,
      remains: remains ?? this.remains,
      periodOfUse: periodOfUse ?? this.periodOfUse,
    );
  }
}