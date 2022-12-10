import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';

abstract class CheckRifaEvents {}

class BtnAddRifa extends CheckRifaEvents {
  final String rifa;
  final num value;

  BtnAddRifa(this.rifa, this.value);
}

class BtnCheckRifa extends CheckRifaEvents {
  final List<RifaEntity> rifas;

  BtnCheckRifa(this.rifas);
}

class BtnLimpar extends CheckRifaEvents {}
