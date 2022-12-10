import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';

abstract class CheckRifaStates {}

class IdleState extends CheckRifaStates {}

class ErrorState extends CheckRifaStates {
  final String msg;

  ErrorState(this.msg);
}

class LoadingState extends CheckRifaStates {}

class AddSuccessState extends CheckRifaStates {
  final RifaEntity rifa;

  AddSuccessState(this.rifa);
}

class ShowResultState extends CheckRifaStates {
  final List<PlayerEntity> players;

  ShowResultState(this.players);
}
