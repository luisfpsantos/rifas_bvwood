import 'package:dartz/dartz.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/choice_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/edit_rifa_exceptions.dart';

abstract class EditRifaUsecase {
  Either<EditRifaExceptions, RifaEntity> call(
      RifaEntity rifa, String oldName, String newName);
}

class EditRifaUsecaseImp implements EditRifaUsecase {
  @override
  Either<EditRifaExceptions, RifaEntity> call(
    RifaEntity rifa,
    String oldName,
    String newName,
  ) {
    if (newName.isEmpty || newName.length <= 3) {
      return left(InvalidArgument('Necessario informar nome'));
    }

    if (newName.trim().toUpperCase() == oldName) {
      return left(InvalidArgument('Novo nome deve ser diferente do atual'));
    }

    num value = 0;
    int times = 0;
    List<ChoiceEntity> choiceNumbers = [];
    bool nameExist = false;

    for (var player in rifa.players) {
      if (player.name == oldName) {
        value = player.value;
        times = player.times;
        choiceNumbers = player.choiceNumbers;
        rifa.players.remove(player);
        break;
      }
    }

    for (var player in rifa.players) {
      if (player.name == newName.trim().toUpperCase()) {
        nameExist = true;
        player.times += times;
        player.choiceNumbers.addAll(choiceNumbers);

        if (player.times > rifa.numbersPromotion) {
          player.value = times * rifa.promotionValue;
        } else {
          player.value += value;
        }

        break;
      }
    }

    if (!nameExist) {
      rifa.players.add(PlayerEntity(
        name: newName.trim().toUpperCase(),
        value: value,
        times: times,
        choiceNumbers: choiceNumbers,
      ));
    }

    rifa.players.sort((a, b) => a.name.compareTo(b.name));

    return right(rifa);
  }
}
