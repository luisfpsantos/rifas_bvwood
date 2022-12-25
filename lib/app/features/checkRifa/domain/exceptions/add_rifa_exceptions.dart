abstract class AddRifaExceptions {
  final String msg;

  AddRifaExceptions(this.msg);
}

class InvalidArgument extends AddRifaExceptions {
  InvalidArgument(super.msg);
}

class UnableToDetect extends AddRifaExceptions {
  UnableToDetect(super.msg);
}
