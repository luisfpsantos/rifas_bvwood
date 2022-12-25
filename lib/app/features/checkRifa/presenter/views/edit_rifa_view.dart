import 'package:flutter/material.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/player_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/entities/rifa_entity.dart';
import 'package:rifas_bvwood/app/features/checkRifa/domain/usecases/edit_rifa_usecase.dart';

class EditRifaView extends StatefulWidget {
  final RifaEntity rifa;
  const EditRifaView({required this.rifa, super.key});

  @override
  State<EditRifaView> createState() => _EditRifaViewState();
}

class _EditRifaViewState extends State<EditRifaView> {
  final teste = EditRifaUsecaseImp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: Colors.blue[100],
        title: Text('Editar Rifa ${widget.rifa.id}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(thickness: 1),
              itemCount: widget.rifa.players.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(widget.rifa.players[i].name),
                  onTap: () => _editModal(context, widget.rifa.players[i]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Números jogados: ${widget.rifa.players[i].times}'),
                      Text(
                        'Valor: R\$ ${widget.rifa.players[i].value.toStringAsFixed(2)}',
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _editModal(BuildContext context, PlayerEntity player) {
    final newName = TextEditingController(text: player.name);

    showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nome do jogador'),
                  TextFormField(
                    controller: newName,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Dezenas jogadas nesta rifa:'),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: player.choiceNumbers.length,
                        itemBuilder: (_, i) =>
                            Text('${player.choiceNumbers[i].number}'),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          teste(widget.rifa, player.name, newName.text);
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Editar'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
