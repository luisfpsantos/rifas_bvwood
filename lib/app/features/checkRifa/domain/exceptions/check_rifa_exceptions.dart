abstract class CheckRifaExceptions {}

class InvalidArgumentOnCheck extends CheckRifaExceptions {
  final String msg;

  InvalidArgumentOnCheck(this.msg);
}

class NamesNotFound extends CheckRifaExceptions {}
