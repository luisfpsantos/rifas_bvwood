import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/add_rifa_usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/add_rifa_bloc.dart/add_rifa_events.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/add_rifa_bloc.dart/add_rifa_states.dart';

class AddRifaBloc extends Bloc<AddRifaEvents, AddRifaStates> {
  final AddRifaUsecase _addRifaUsecase;

  AddRifaBloc(this._addRifaUsecase) : super(AddIdleState()) {
    on<OnBtnAddRifaPressed>((event, emit) => _addRifa(event, emit));
  }

  void _addRifa(OnBtnAddRifaPressed event, emit) {
    emit(AddLoadingState());

    final result = _addRifaUsecase(
      event.rifa,
      event.value,
      event.promocao,
      event.valuePromocao,
    );

    result.fold(
      (error) => emit(AddErrorState(error.msg)),
      (succes) => emit(AddSuccessState(succes)),
    );
  }
}
