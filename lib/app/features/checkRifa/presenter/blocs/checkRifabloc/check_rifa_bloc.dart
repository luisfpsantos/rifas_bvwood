import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/check_rifa.usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_events.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_states.dart';

class CheckRifaBloc extends Bloc<CheckRifaEvents, CheckRifaStates> {
  final CheckRifaUsecase _checkRifaUsecase;

  CheckRifaBloc(
    this._checkRifaUsecase,
  ) : super(IdleState()) {
    on<BtnCheckRifa>((event, emit) => _checkRifa(event, emit));
    on<OnHaveRifas>((event, emit) => emit(HaveRifasState()));
    on<BtnRemoveRifa>((event, emit) => _removeRifa(event, emit));
  }

  void _checkRifa(event, emit) {
    emit(LoadingState());

    final result = _checkRifaUsecase(event.rifas);

    result.fold(
      (error) => emit(ErrorState(error.msg)),
      (succes) => emit(ShowResultState(succes)),
    );
  }

  void _removeRifa(BtnRemoveRifa event, emit) {
    emit(LoadingState());
    event.rifas.remove(event.rifaToRemove);

    if (event.rifas.isNotEmpty) {
      emit(HaveRifasState());
      return;
    }

    emit(IdleState());
  }
}
