import 'package:fpdart/fpdart.dart';
import 'package:twitter/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;
