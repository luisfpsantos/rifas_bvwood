import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/add_rifa_usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/check_rifa.usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_events.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_states.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/checkRifabloc/check_rifa_bloc.dart';

class CheckRifaView extends StatefulWidget {
  const CheckRifaView({super.key});

  @override
  State<CheckRifaView> createState() => _CheckRifaViewState();
}

class _CheckRifaViewState extends State<CheckRifaView> {
  final bloc = CheckRifaBloc(
    AddRifaUsecaseImp(),
    CheckRifaUsecaseImp(),
  );
  final rifaController = TextEditingController();
  final valorRifaFormatter = CurrencyTextInputFormatter(
    symbol: 'R\$',
    locale: "pt-br",
  );
  final valorController = TextEditingController();
  final snackBar = const SnackBar(content: Text("Copido com sucesso!"));
  List<RifaEntity> rifas = [];
  int numeros = 0;
  num total = 0;
  bool comValor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conferencia Rifas')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: const Text('Insira o valor da rifa:')),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: valorController,
                        inputFormatters: [valorRifaFormatter],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 10)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<CheckRifaBloc, CheckRifaStates>(
                      bloc: bloc,
                      builder: (_, state) {
                        Widget btn = Container();

                        if (state is! IdleState) {
                          btn = ElevatedButton(
                            onPressed: () {
                              rifas = [];
                              numeros = 0;
                              total = 0;
                              rifaController.text = '';
                              valorController.text = '';
                              bloc.add(BtnLimpar());
                            },
                            child: const Text('Limpar'),
                          );
                        }

                        return btn;
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<CheckRifaBloc, CheckRifaStates>(
                      bloc: bloc,
                      builder: (context, state) {
                        Widget title = Container();

                        if (state is AddSuccessState) {
                          title = Text(
                            'rifa ${state.rifa.id} adicionada. Total: ${rifas.length}',
                            style: const TextStyle(color: Colors.green),
                          );
                        }

                        return title;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BlocBuilder<CheckRifaBloc, CheckRifaStates>(
                      bloc: bloc,
                      builder: (context, state) {
                        Widget title = const Text('Cole a rifa Abaixo:');

                        if (state is ErrorState) {
                          title = Text(
                            state.msg,
                            style: const TextStyle(color: Colors.red),
                          );
                        }

                        if (state is ShowResultState) {
                          numeros = 0;
                          total = 0;
                          for (var i in rifas) {
                            for (var j in i.players) {
                              numeros += j.times;
                              total += j.value;
                            }
                          }
                          title = Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                    'Números conferidos: $numeros. Valor total: R\$ ${total.toStringAsFixed(2)}'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: rifaController.text),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar,
                                  );
                                },
                                child: const Icon(Icons.copy),
                              )
                            ],
                          );
                        }

                        return title;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BlocBuilder<CheckRifaBloc, CheckRifaStates>(
                      bloc: bloc,
                      builder: (context, state) {
                        Widget result = TextField(
                          controller: rifaController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        );

                        if (state is ShowResultState) {
                          String s = 'Lista com dezenas escolhidas:\n\n';
                          if (comValor) {
                            for (var player in state.players) {
                              s +=
                                  '${player.name} ${player.times} - R\$: ${player.value.toStringAsFixed(2)}\n\n';
                            }
                          } else {
                            for (var player in state.players) {
                              s += '${player.name} ${player.times}\n\n';
                            }
                          }

                          rifaController.text = s;
                          result = TextField(
                            controller: rifaController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            readOnly: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                          );
                        }

                        if (state is LoadingState) {
                          result = const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return result;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: BlocConsumer<CheckRifaBloc, CheckRifaStates>(
                        bloc: bloc,
                        listener: (context, state) {
                          if (state is AddSuccessState) {
                            rifas.add(state.rifa);
                          }
                        },
                        builder: (_, state) {
                          Widget options = Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  bloc.add(BtnAddRifa(
                                    rifaController.text,
                                    valorRifaFormatter.getUnformattedValue(),
                                  ));

                                  rifaController.text = '';
                                  valorController.text = '';
                                },
                                child: const Text('Adicioar/Validar rifa'),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  bloc.add(BtnCheckRifa(rifas));
                                },
                                child: const Text('Conferir'),
                              ),
                              Checkbox(
                                  value: comValor,
                                  onChanged: (value) {
                                    setState(() {
                                      comValor = value!;
                                    });
                                  }),
                              const Expanded(child: Text('Com valor?'))
                            ],
                          );

                          if (state is LoadingState) {
                            options = const CircularProgressIndicator();
                          }

                          if (state is ShowResultState) {
                            options = Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    bloc.add(BtnAddRifa(
                                      rifaController.text,
                                      valorRifaFormatter.getUnformattedValue(),
                                    ));

                                    rifaController.text = '';
                                    valorController.text = '';
                                  },
                                  child: const Text('Adicioar/Validar rifa'),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    bloc.add(BtnCheckRifa(rifas));
                                  },
                                  child: const Text('Conferir'),
                                ),
                                Checkbox(
                                    value: comValor,
                                    onChanged: (value) {
                                      setState(() {
                                        comValor = value!;
                                      });
                                    }),
                                const Expanded(child: Text('Com valor?'))
                              ],
                            );
                          }

                          return options;
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
