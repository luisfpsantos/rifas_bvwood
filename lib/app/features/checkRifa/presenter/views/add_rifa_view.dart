import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/add_rifa_usecase.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/add_rifa_bloc.dart/add_rifa_bloc.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/add_rifa_bloc.dart/add_rifa_events.dart';
import 'package:rifas_bvwood/app/features/checkRifa/presenter/blocs/add_rifa_bloc.dart/add_rifa_states.dart';

class AddRifaView extends StatefulWidget {
  const AddRifaView({super.key});

  @override
  State<AddRifaView> createState() => _AddRifaViewState();
}

class _AddRifaViewState extends State<AddRifaView> {
  late final AddRifaBloc _bloc;
  final _numPromocao = TextEditingController();
  final _rifa = TextEditingController();
  final _valorRifaFormatter =
      CurrencyTextInputFormatter(symbol: 'R\$', locale: "pt-br");
  final _valorPromocao =
      CurrencyTextInputFormatter(symbol: 'R\$', locale: "pt-br");

  bool _flagPromocao = false;
  Widget _promocao = Container();

  @override
  void initState() {
    super.initState();
    _bloc = AddRifaBloc(AddRifaUsecaseImp());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: Colors.blue[100],
        title: const Text('Adicionar Rifa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('Valor da rifa'),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  inputFormatters: [_valorRifaFormatter],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(children: [
                const Text('Promoção'),
                Checkbox(
                    value: _flagPromocao,
                    onChanged: (value) {
                      setState(() {
                        _flagPromocao = value!;
                        if (_flagPromocao) {
                          _promocao = _buildInputPromocao();
                        } else {
                          _promocao = Container();
                        }
                      });
                    })
              ])
            ]),
            _promocao,
            const SizedBox(height: 15),
            const Divider(color: Colors.black26, thickness: 2),
            const SizedBox(height: 10),
            const Text('Cole a rifa abaixo'),
            const SizedBox(height: 10),
            BlocConsumer<AddRifaBloc, AddRifaStates>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is AddSuccessState) {
                  Navigator.pop(context, state.rifa);
                }
              },
              builder: (context, state) {
                Widget errorMsg = Container();

                if (state is AddErrorState) {
                  errorMsg = Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      state.msg,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                if (state is AddLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                Widget body = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    errorMsg,
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height - 400),
                      child: TextField(
                        controller: _rifa,
                        expands: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _onBtnAddRifaPressed,
                      child: const Text('Adicionar'),
                    )
                  ],
                );

                return body;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onBtnAddRifaPressed() {
    if (_flagPromocao) {
      _bloc.add(OnBtnAddRifaPressed(
        rifa: _rifa.text,
        value: _valorRifaFormatter.getUnformattedValue(),
        promocao: int.tryParse(_numPromocao.text),
        valuePromocao: _valorPromocao.getUnformattedValue(),
      ));
    } else {
      _bloc.add(OnBtnAddRifaPressed(
        rifa: _rifa.text,
        value: _valorRifaFormatter.getUnformattedValue(),
      ));
    }
  }

  Widget _buildInputPromocao() {
    return Row(children: [
      const Text('Acima de'),
      const SizedBox(width: 10),
      Expanded(
        child: TextField(
          controller: _numPromocao,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 10),
      const Text('Valor é:'),
      const SizedBox(width: 10),
      Expanded(
        child: TextField(
          inputFormatters: [_valorPromocao],
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(),
          ),
        ),
      )
    ]);
  }
}
