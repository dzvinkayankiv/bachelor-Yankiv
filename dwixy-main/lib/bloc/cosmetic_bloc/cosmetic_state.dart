part of 'cosmetic_bloc.dart';

@immutable
abstract class CosmeticState {}

final class CosmeticInitial extends CosmeticState {}

final class CosmeticLoading extends CosmeticState {}

final class CosmeticSuccess extends CosmeticState {}

final class CosmeticLoaded extends CosmeticState {
  final List<CosmeticModel> cosmeticsModel;

  CosmeticLoaded(this.cosmeticsModel);
}

final class CosmeticError extends CosmeticState {
  final String message;

  CosmeticError(this.message);
}