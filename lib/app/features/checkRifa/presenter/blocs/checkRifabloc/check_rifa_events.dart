import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';

abstract class CheckRifaEvents {}

class BtnAddRifa extends CheckRifaEvents {
  final String rifa;
  final num value;
  final int? promocao;
  final num? valuePromocao;

  BtnAddRifa({
    required this.rifa,
    required this.value,
    this.promocao,
    this.valuePromocao,
  });
}

class BtnCheckRifa extends CheckRifaEvents {
  final List<RifaEntity> rifas;

  BtnCheckRifa(this.rifas);
}

class BtnRemoveRifa extends CheckRifaEvents {
  final List<RifaEntity> rifas;
  final RifaEntity rifaToRemove;

  BtnRemoveRifa(this.rifas, this.rifaToRemove);
}

class OnHaveRifas extends CheckRifaEvents {}

class CleanErrors extends CheckRifaEvents {}
