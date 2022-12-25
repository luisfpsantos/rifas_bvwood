import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';

abstract class CheckRifaStates {}

class IdleState extends CheckRifaStates {}

class ErrorState extends CheckRifaStates {
  final String msg;

  ErrorState(this.msg);
}

class LoadingState extends CheckRifaStates {}

class HaveRifasState extends CheckRifaStates {}

class ShowResultState extends CheckRifaStates {
  final List<PlayerEntity> players;

  ShowResultState(this.players);
}
