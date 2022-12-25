class AddRifaEvents {}

class OnBtnAddRifaPressed extends AddRifaEvents {
  final String rifa;
  final num value;
  final int? promocao;
  final num? valuePromocao;

  OnBtnAddRifaPressed({
    required this.rifa,
    required this.value,
    this.promocao,
    this.valuePromocao,
  });
}
