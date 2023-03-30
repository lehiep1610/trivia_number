import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/core/usecases/usecase.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_number/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_number/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInterger(any))
            .thenReturn(const Right(tNumberParsed));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned interger',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInterger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInterger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInterger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        Empty(),
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act

      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // asert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten sucessfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, expected);
      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should emit [Loading, Error] when getting data fail', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, expected);
      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.state, expected);
      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    // blocTest('should emit [Error] when the input is invalid',
    //     build: () {
    //       when(mockInputConverter.stringToUnsignedInterger(any))
    //           .thenReturn(Left(InvalidInputFailure()));
    //       return bloc;
    //     },
    //     act: (bloc) => bloc.add(
    //           const GetTriviaForConcreteNumber(numberString: tNumberString),
    //         ),
    //     expect: () => [const Error(message: INVALID_INPUT_FAILURE_MESSAGE)]);
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(const GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // asert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten sucessfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.state, expected);
      // act
      bloc.add(const GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fail', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, expected);
      // act
      bloc.add(const GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.state, expected);
      // act
      bloc.add(const GetTriviaForRandomNumber());
    });

    // blocTest('should emit [Error] when the input is invalid',
    //     build: () {
    //       when(mockInputConverter.stringToUnsignedInterger(any))
    //           .thenReturn(Left(InvalidInputFailure()));
    //       return bloc;
    //     },
    //     act: (bloc) => bloc.add(
    //           const GetTriviaForConcreteNumber(numberString: tNumberString),
    //         ),
    //     expect: () => [const Error(message: INVALID_INPUT_FAILURE_MESSAGE)]);
  });
}
