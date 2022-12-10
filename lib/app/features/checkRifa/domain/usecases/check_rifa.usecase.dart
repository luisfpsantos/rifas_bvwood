import 'package:dartz/dartz.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/check_rifa_exceptions.dart';

abstract class CheckRifaUsecase {
  Either<CheckRifaExceptions, List<PlayerEntity>> call(List<RifaEntity> rifas);
}

class CheckRifaUsecaseImp implements CheckRifaUsecase {
  @override
  Either<CheckRifaExceptions, List<PlayerEntity>> call(
    List<RifaEntity> rifas,
  ) {
    if (rifas.isEmpty) {
      return left(InvalidArgumentOnCheck('Necessario Adicioar rifa primeiro'));
    }

    List<String> playersNames = [];
    for (var rifa in rifas) {
      for (var player in rifa.players) {
        if (!playersNames.contains(player.name)) {
          playersNames.add(player.name);
        }
      }
    }

    List<PlayerEntity> players = [];
    for (var name in playersNames) {
      int vezes = 0;
      num value = 0;
      for (var rifa in rifas) {
        for (var player in rifa.players) {
          if (name == player.name) {
            vezes += player.times;
            value += player.value;
            break;
          }
        }
      }
      players.add(PlayerEntity(name: name, value: value, times: vezes));
    }

    players.sort((a, b) => a.name.compareTo(b.name));

    return right(players);
  }
}
