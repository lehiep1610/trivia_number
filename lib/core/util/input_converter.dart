import 'package:dartz/dartz.dart';
import 'package:trivia_number/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInterger(String str) {
    try {
      final interger = int.parse(str);
      if (interger < 0) throw const FormatException();
      return Right(interger);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
