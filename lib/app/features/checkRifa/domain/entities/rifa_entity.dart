// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';

class RifaEntity {
  int id;
  num value;
  num promotionValue;
  int numbersPromotion;
  String rifa;
  List<PlayerEntity> players;

  RifaEntity({
    required this.id,
    required this.value,
    required this.promotionValue,
    required this.numbersPromotion,
    required this.rifa,
    required this.players,
  });
}
