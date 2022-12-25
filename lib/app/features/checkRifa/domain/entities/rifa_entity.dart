import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';

class RifaEntity {
  int id;
  num value;
  String rifa;
  List<PlayerEntity> players;

  RifaEntity({
    required this.id,
    required this.value,
    required this.players,
    required this.rifa,
  });
}
