import 'package:dartz/dartz.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/choice_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/add_rifa_exceptions.dart';

abstract class AddRifaUsecase {
  Either<AddRifaExceptions, RifaEntity> call(
    String rifa,
    num value,
    int? promocao,
    num? valorPromocao,
  );
}

class AddRifaUsecaseImp implements AddRifaUsecase {
  @override
  Either<AddRifaExceptions, RifaEntity> call(
    String rifa,
    num value,
    int? promocao,
    num? valorPromocao,
  ) {
    if (rifa.isEmpty) {
      return left(InvalidArgument('É necessario informar a rifa'));
    }
    if (value <= 0) {
      return left(InvalidArgument('Valor da rifa deve ser maior que 0'));
    }
    if (promocao == null && valorPromocao != null) {
      return left(InvalidArgument('É necessario informar numero da promoção'));
    }
    if (promocao != null && valorPromocao == null) {
      return left(InvalidArgument('É necessario informar valor da promoção'));
    }
    if (promocao != null && promocao <= 0) {
      return left(InvalidArgument('É necessario informar numero da promoção'));
    }
    if (valorPromocao != null && valorPromocao <= 0) {
      return left(InvalidArgument('É necessario informar valor da promoção'));
    }

    final regExpNumberRifa = RegExp(r'[0-9]+');

    final regExpPlayers = RegExp(
      r'[0-9]{2}\-(\s)?[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]+((\s)?([A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]+)?)*',
    );

    final idMatch = regExpNumberRifa.firstMatch(rifa);

    if (idMatch == null) {
      return left(UnableToDetect('Não foi possivel encontrar número da rifa'));
    }

    final rifaId = rifa.substring(idMatch.start, idMatch.end).trim();
    final playersMatch = regExpPlayers.allMatches(rifa);

    if (playersMatch.isEmpty || playersMatch.length < 100) {
      return left(UnableToDetect('Não foi possivel encontrar 100 jogadores'));
    }

    List<Map<String, dynamic>> playersWithChoice = [];
    List<String> playerNames = [];
    for (var name in playersMatch) {
      playersWithChoice.add(
        {
          'name': rifa.substring(name.start + 3, name.end).trim().toUpperCase(),
          'choiceNumber': int.parse(
            rifa.substring(name.start, name.start + 2).trim(),
          )
        },
      );
      playerNames.add(
        rifa.substring(name.start + 3, name.end).trim().toUpperCase(),
      );
    }

    List<String> playerNamesDistinct = playerNames.toSet().toList();

    List<PlayerEntity> players = [];
    for (var playerNameDistinct in playerNamesDistinct) {
      int times = 0;
      List<ChoiceEntity> choices = [];
      for (var player in playersWithChoice) {
        if (playerNameDistinct == player['name']) {
          times++;
          choices.add(ChoiceEntity(
            number: player['choiceNumber'],
            idRifa: int.parse(rifaId),
          ));
        }
      }
      if (promocao != null && valorPromocao != null) {
        players.add(PlayerEntity(
            name: playerNameDistinct,
            value: times > promocao ? times * valorPromocao : value * times,
            times: times,
            choiceNumbers: choices));
      } else {
        players.add(PlayerEntity(
            name: playerNameDistinct,
            value: value * times,
            times: times,
            choiceNumbers: choices));
      }
    }

    players.sort((a, b) => a.name.compareTo(b.name));

    return right(
      RifaEntity(
        id: int.parse(rifaId),
        value: value,
        players: players,
        rifa: rifa,
      ),
    );
  }
}
