import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/choice_entity.dart';

class PlayerEntity {
  String name;
  num value;
  int times;
  List<ChoiceEntity> choiceNumbers;

  PlayerEntity({
    required this.name,
    required this.value,
    required this.times,
    required this.choiceNumbers,
  });
}
