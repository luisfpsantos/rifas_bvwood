import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget result = Container();
  Widget options = const SizedBox();
  Widget rifasAdicionadas = Container();
  int nroRifas = 0;
  String allRifas = '';
  num valoresRifas = 0;
  final rifa = TextEditingController();
  final valorRifa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rifas BVWOOD'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Qual o valor da rifa:'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: valorRifa,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          result = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Cole a rifa abaixo:'),
                              const SizedBox(height: 5),
                              TextField(
                                controller: rifa,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ],
                          );
                          options = Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    valoresRifas = valoresRifas +
                                        num.parse(valorRifa.text);
                                    nroRifas++;
                                    allRifas = allRifas + rifa.text;
                                    setState(() {
                                      rifasAdicionadas = Text(
                                        'Rifas Adicionadas: $nroRifas',
                                      );
                                      valorRifa.text = '';
                                      rifa.text = '';
                                    });
                                  },
                                  child: const Text('Adicionar outra'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    valoresRifas = valoresRifas +
                                        num.parse(valorRifa.text);
                                    nroRifas++;
                                    allRifas = allRifas + rifa.text;

                                    var names = _getNamesFromRifa(allRifas);
                                    var jogadores = _calculate(
                                      names,
                                      valoresRifas,
                                    );

                                    nroRifas = 0;
                                    allRifas = '';
                                    valoresRifas = 0;

                                    setState(() {
                                      rifasAdicionadas = Container();
                                      rifa.text = jogadores;
                                    });
                                  },
                                  child: const Text('Calcular'),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                      child: const Text('Iniciar'),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                rifasAdicionadas,
                const SizedBox(height: 15),
                Expanded(child: result),
                options
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getNamesFromRifa(String rifa) {
    //REGEX PARA PEGAR PADRÃO DE NOMES NA RIFA
    final regExp = RegExp(
      r'[0-9]{2}\-[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]+((\s)?([A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]+)?)*',
    );

    //INTERANDO SOBRE CADA PADRÃO PARA PEGAR SOMENTE OS NOMES
    List<String> allNames = [];
    for (var nome in regExp.allMatches(rifa)) {
      allNames.add(
        rifa.substring(nome.start + 3, nome.end).trim().toUpperCase(),
      );
    }

    return allNames;
  }

  String _calculate(List<String> allNames, num valorRifa) {
    //FILTRANDO APENAS NOMES DISTINTOS
    List<String> names = allNames.toSet().toList();
    List<Jogador> jogadores = [];
    for (var name in names) {
      int times = 0;
      for (var allName in allNames) {
        if (name == allName) {
          times++;
        }
      }
      jogadores.add(
        Jogador(times: times, name: name, value: valorRifa * times),
      );
    }

    jogadores.sort((a, b) => a.name.compareTo(b.name));

    String b = '';
    for (var a in jogadores) {
      b = b + '${a.name} - ${a.times} - ${a.value} \n';
    }

    return b;
  }
}

class Jogador {
  final int times;
  final String name;
  final num value;

  Jogador({required this.times, required this.name, required this.value});
}
