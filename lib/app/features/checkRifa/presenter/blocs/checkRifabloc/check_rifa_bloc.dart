import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/add_rifa_exceptions.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/exceptions/check_rifa_exceptions.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/add_rifa_usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/check_rifa.usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_events.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_states.dart';

class CheckRifaBloc extends Bloc<CheckRifaEvents, CheckRifaStates> {
  final AddRifaUsecase _addRifaUsecase;
  final CheckRifaUsecase _checkRifaUsecase;

  CheckRifaBloc(
    this._addRifaUsecase,
    this._checkRifaUsecase,
  ) : super(IdleState()) {
    on<BtnAddRifa>((event, emit) => _addRifa(event, emit));
    on<BtnCheckRifa>((event, emit) => _checkRifa(event, emit));
    on<BtnLimpar>((event, emit) => emit(IdleState()));
  }

  void _addRifa(event, emit) {
    emit(LoadingState());
    final result = _addRifaUsecase(event.rifa, event.value);
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

  void _checkRifa(event, emit) {
    emit(LoadingState());
    final result = _checkRifaUsecase(event.rifas);
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
