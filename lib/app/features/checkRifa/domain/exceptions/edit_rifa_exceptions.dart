class EditRifaExceptions {
  final String msg;

  EditRifaExceptions(this.msg);
}

class InvalidArgument extends EditRifaExceptions {
  InvalidArgument(super.msg);
}
