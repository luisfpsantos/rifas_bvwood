import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';

class AddRifaStates {}

class AddErrorState extends AddRifaStates {
  final String msg;

  AddErrorState(this.msg);
}

class AddSuccessState extends AddRifaStates {
  final RifaEntity rifa;

  AddSuccessState(this.rifa);
}

class AddLoadingState extends AddRifaStates {}

class AddIdleState extends AddRifaStates {}
