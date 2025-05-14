part of 'cosmetic_bloc.dart';

@immutable
abstract class CosmeticEvent {}

class PushCosmetic extends CosmeticEvent {
  final String type;
  final String name;
  final String size;
  final Timestamp expirationDate;
  final Timestamp openDate;
  final num remains;
  final String periodOfUse;
  final String imageUrl;
  final File image;

  PushCosmetic({
    required this.type,
    required this.name,
    required this.size,
    required this.expirationDate,
    required this.openDate,
    required this.remains,
    required this.periodOfUse,
    required this.imageUrl,
    required this.image,
  });
}

class GetCosmetic extends CosmeticEvent {}

class DeleteCosmetic extends CosmeticEvent {
  final String id;
  final String imageUrl;

  DeleteCosmetic(this.id, this.imageUrl);
}

class PutCosmetic extends CosmeticEvent {
  final String id;
  final String type;
  final String name;
  final String size;
  final Timestamp expirationDate;
  final Timestamp openDate;
  final num remains;
  final String periodOfUse;
  final String imageUrl;
  final File image;

  PutCosmetic({
    required this.id,
    required this.type,
    required this.name,
    required this.size,
    required this.expirationDate,
    required this.openDate,
    required this.remains,
    required this.periodOfUse,
    required this.imageUrl,
    required this.image,
  });
}

class TodayUsedCosmetic extends CosmeticEvent {
  final double newValue;
  final String id;

  TodayUsedCosmetic(this.newValue, this.id);
}
