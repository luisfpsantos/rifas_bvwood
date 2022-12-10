import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/add_rifa_usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/check_rifa.usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/stores/checkRifaStore/check_rifa_states.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/stores/checkRifaStore/check_rifa_store.dart';

class CheckRifaView extends StatefulWidget {
  const CheckRifaView({super.key});

  @override
  State<CheckRifaView> createState() => _CheckRifaViewState();
}

class _CheckRifaViewState extends State<CheckRifaView> {
  final store = CheckRifaStore(
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

  @override
  Widget build(BuildContext context) {
    store.addListener(() {
      if (store.value is AddSuccessState) {
        rifas.add((store.value as AddSuccessState).rifa);
      }

      if (store.value is ShowResultState) {
        for (var player in (store.value as ShowResultState).players) {
          numeros += player.times;
        }
      }
    });

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
                    ValueListenableBuilder<CheckRifaStates>(
                      valueListenable: store,
                      builder: (context, state, _) {
                        Widget btn = Container();

                        if (state is! IdleState) {
                          btn = ElevatedButton(
                            onPressed: () {
                              rifas = [];
                              rifaController.text = '';
                              valorController.text = '';
                              store.value = IdleState();
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder<CheckRifaStates>(
                      valueListenable: store,
                      builder: (context, state, _) {
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
                    ValueListenableBuilder<CheckRifaStates>(
                      valueListenable: store,
                      builder: (context, state, _) {
                        Widget title = const Text('Cole a rifa Abaixo:');

                        if (state is ErrorState) {
                          title = Text(
                            state.msg,
                            style: const TextStyle(color: Colors.red),
                          );
                        }

                        if (state is ShowResultState) {
                          title = Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Resultado: $numeros conferidos'),
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
                    ValueListenableBuilder<CheckRifaStates>(
                      valueListenable: store,
                      builder: (context, state, _) {
                        Widget result = TextField(
                          controller: rifaController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        );

                        if (state is ShowResultState) {
                          String s = 'Lista com dezenas escolhidas:\n';
                          for (var player in state.players) {
                            s += '${player.name} ${player.times}\n';
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

                        return result;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: ValueListenableBuilder<CheckRifaStates>(
                        valueListenable: store,
                        builder: (context, state, _) {
                          Widget options = Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    store.addRifa(
                                      rifaController.text,
                                      valorRifaFormatter.getUnformattedValue(),
                                    );
                                    rifaController.text = '';
                                    valorController.text = '';
                                  },
                                  child: const Text('Adicioar/Validar rifa')),
                              const SizedBox(width: 50),
                              ElevatedButton(
                                  onPressed: () {
                                    store.checkRifa(rifas);
                                  },
                                  child: const Text('Conferir'))
                            ],
                          );

                          if (state is LoadingState) {
                            options = const CircularProgressIndicator();
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
