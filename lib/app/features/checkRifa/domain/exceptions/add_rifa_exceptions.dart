abstract class AddRifaExceptions {}

class InvalidArgument extends AddRifaExceptions {
  final String msg;

  InvalidArgument(this.msg);
}

class UnableToDetect extends AddRifaExceptions {
  final String msg;

  UnableToDetect(this.msg);
}
