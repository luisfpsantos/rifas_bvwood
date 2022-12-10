import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';

class RifaEntity {
  final int id;
  final num value;
  final List<PlayerEntity> players;

  RifaEntity({required this.id, required this.value, required this.players});
}
