import 'package:flutter/cupertino.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/add_rifa_exceptions.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/check_rifa_exceptions.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/add_rifa_usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/check_rifa.usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/stores/checkRifaStore/check_rifa_states.dart';

class CheckRifaStore extends ValueNotifier<CheckRifaStates> {
  final AddRifaUsecase _addRifaUsecase;
  final CheckRifaUsecase _checkRifaUsecase;

  CheckRifaStore(
    this._addRifaUsecase,
    this._checkRifaUsecase,
  ) : super(IdleState());

  void emit(CheckRifaStates state) {
    value = state;
  }

  void addRifa(String rifa, num value) {
    emit(LoadingState());
    final result = _addRifaUsecase(rifa, value);
    result.fold(
      (error) {
        if (error is InvalidArgument) {
          emit(ErrorState(error.msg));
        }

        if (error is UnableToDetect) {
          emit(ErrorState(error.msg));
        }
      },
      (succes) => emit(AddSuccessState(succes)),
    );
  }

  void checkRifa(List<RifaEntity> rifas) {
    emit(LoadingState());
    final result = _checkRifaUsecase(rifas);
    result.fold(
      (error) {
        if (error is InvalidArgumentOnCheck) {
          emit(ErrorState(error.msg));
        }

        if (error is NamesNotFound) {
          emit(ErrorState('Não foi possivel encontrar os nomes na rifa'));
        }
      },
      (succes) => emit(ShowResultState(succes)),
    );
  }
}
