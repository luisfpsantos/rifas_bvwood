abstract class CheckRifaExceptions {
  final String msg;

  CheckRifaExceptions(this.msg);
}

class InvalidArgumentOnCheck extends CheckRifaExceptions {
  InvalidArgumentOnCheck(super.msg);
}

class NamesNotFound extends CheckRifaExceptions {
  NamesNotFound(super.msg);
}
