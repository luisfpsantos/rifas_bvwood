import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/check_rifa.usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_events.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_states.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/views/add_rifa_view.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/views/edit_rifa_view.dart';

class CheckRifaView extends StatefulWidget {
  const CheckRifaView({super.key});

  @override
  State<CheckRifaView> createState() => _CheckRifaViewState();
}

class _CheckRifaViewState extends State<CheckRifaView> {
  final _bloc = CheckRifaBloc(CheckRifaUsecaseImp());
  final List<RifaEntity> rifas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Conferir Rifa",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => _addRifaModal(context),
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: BlocBuilder<CheckRifaBloc, CheckRifaStates>(
          bloc: _bloc,
          builder: (context, state) {
            print(state);
            Widget body = Container();

            if (state is IdleState) {
              body = Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                          text:
                              'Para conferir as rifas é necessario adiciona-las primeiro no botão: ',
                          style: TextStyle(fontSize: 18)),
                      TextSpan(
                          text: '+',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }

            if (state is HaveRifasState) {
              body = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rifas adicionadas abaixo:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.separated(
                      itemCount: rifas.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (_, i) {
                        return ListTile(
                          title: Text('Rifa ${rifas[i].id}'),
                          tileColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          trailing: IconButton(
                              onPressed: () => _editRifaModal(_, rifas[i]),
                              icon: const Icon(Icons.edit)),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return body;
          },
        ),
      ),
    );
  }

  void _editRifaModal(BuildContext context, RifaEntity rifa) async {
    var editRifa = await showModalBottomSheet(
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 50),
      context: context,
      builder: (context) {
        return EditRifaView(rifa: rifa);
      },
    );
  }

  void _addRifaModal(BuildContext context) async {
    var rifa = await showModalBottomSheet<RifaEntity>(
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 50),
      context: context,
      builder: (context) {
        return const AddRifaView();
      },
    );

    if (rifa is RifaEntity) {
      rifas.add(rifa);
    }

    if (rifas.isNotEmpty) {
      _bloc.add(OnHaveRifas());
    }
  }
}
