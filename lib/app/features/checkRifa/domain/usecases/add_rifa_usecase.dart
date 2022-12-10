import 'package:dartz/dartz.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/add_rifa_exceptions.dart';

abstract class AddRifaUsecase {
  Either<AddRifaExceptions, RifaEntity> call(String rifa, num value);
}

class AddRifaUsecaseImp implements AddRifaUsecase {
  @override
  Either<AddRifaExceptions, RifaEntity> call(String rifa, num value) {
    if (rifa.isEmpty) {
      return left(InvalidArgument('Rifa is necessary'));
    }

    if (value <= 0) {
      return left(InvalidArgument('value have to be grater than 0'));
    }

    final regExpNumberRifa = RegExp(r'[0-9]+');

    final regExpPlayers = RegExp(
      r'[0-9]{2}\-(\s)?[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]+((\s)?([A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]+)?)*',
    );

    final idMatch = regExpNumberRifa.firstMatch(rifa);

    if (idMatch == null) {
      return left(UnableToDetect('cant find id rifa'));
    }

    final rifaId = rifa.substring(idMatch.start, idMatch.end);
    final playersMatch = regExpPlayers.allMatches(rifa);

    if (playersMatch.isEmpty || playersMatch.length < 100) {
      return left(UnableToDetect('cant find all players'));
    }

    List<String> playerNames = [];
    for (var name in playersMatch) {
      playerNames.add(
        rifa.substring(name.start + 3, name.end).trim().toUpperCase(),
      );
    }

    List<String> playerNamesDistinct = playerNames.toSet().toList();
    List<PlayerEntity> players = [];
    for (var playerNameDistinct in playerNamesDistinct) {
      int times = 0;
      for (var playerName in playerNames) {
        if (playerNameDistinct == playerName) {
          times++;
        }
      }
      players.add(PlayerEntity(
          name: playerNameDistinct, value: value * times, times: times));
    }

    return right(
      RifaEntity(id: int.parse(rifaId), value: value, players: players),
    );
  }
}
