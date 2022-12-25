import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';
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
        child: BlocConsumer<CheckRifaBloc, CheckRifaStates>(
          bloc: _bloc,
          listener: (_, state) {
            if (state is ShowResultState) _resultDialog(_, state.players);
          },
          builder: (context, state) {
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

            if (state is HaveRifasState || state is ShowResultState) {
              body = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rifas adicionadas abaixo:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Scrollbar(
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
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () => _bloc.add(BtnCheckRifa(rifas)),
                      child: const Text('Conferir rifas')),
                  const SizedBox(height: 10),
                ],
              );
            }

            return body;
          },
        ),
      ),
    );
  }

  void _resultDialog(BuildContext context, List<PlayerEntity> players) async {
    final result = TextEditingController();
    bool showNamesWithValues = false;
    bool showAll = false;

    String rifaWithoutValues = '';
    String rifaWithValues = '';
    String rifaAll = '';
    num valorTotal = 0;
    int numeros = 0;

    for (var player in players) {
      valorTotal += player.value;
      numeros += player.choiceNumbers.length;
      rifaWithoutValues += '${player.name} ${player.times}\n\n';
      rifaWithValues +=
          '${player.name} ${player.times} __ R\$ ${player.value.toStringAsFixed(2)}\n\n';
      rifaAll +=
          '${player.name} ${player.times} __ R\$ ${player.value.toStringAsFixed(2)}\n     ${player.choiceNumbers.map((e) => 'N° ${e.number.toString().padLeft(2, '0')} __ Rifa: ${e.idRifa}\n     ').join()}\n\n';
    }

    result.text = rifaAll;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.white,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Resultados'),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: result.text));
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copiado com sucesso!')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                )
              ],
            ),
            body: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Valor total das rifa(s): '),
                        TextSpan(
                          text: 'R\$ ${valorTotal.toStringAsFixed(2)}\n',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: 'Números jogados: '),
                        TextSpan(
                          text: '$numeros',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Row(children: [
                    const Text('Mostrar nomes c/valores?'),
                    Switch(
                        value: showNamesWithValues,
                        onChanged: (value) {
                          setState(() {
                            showNamesWithValues = value;
                            if (showNamesWithValues) {
                              showAll = false;
                              result.text = rifaWithValues;
                            } else {
                              result.text = rifaWithoutValues;
                            }
                          });
                        })
                  ]),
                  Row(children: [
                    const Text('Mostrar tudo?'),
                    Switch(
                        value: showAll,
                        onChanged: (value) {
                          setState(() {
                            showAll = value;
                            if (showAll) {
                              showNamesWithValues = false;
                              result.text = rifaAll;
                            } else {
                              result.text = rifaWithoutValues;
                            }
                          });
                        })
                  ]),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TextField(
                      controller: result,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      readOnly: true,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editRifaModal(BuildContext context, RifaEntity rifa) async {
    await showModalBottomSheet(
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
