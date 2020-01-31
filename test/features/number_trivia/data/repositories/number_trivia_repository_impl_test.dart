import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/network/network_info.dart';
import 'package:flutter_seed/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_seed/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_seed/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_seed/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_seed/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  MockNumberTriviaLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  NumberTriviaRepository repository;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource, localDataSource: mockLocalDataSource, networkInfo: mockNetworkInfo);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: tNumber, text: 'Test text');
  final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'Test text');

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    runTestsOnline(() {
      test(
          'should get a NumberTriviaModel when calling from remote data source succesfully',
              () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getConcreteNumberTrivia(tNumber);

            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, equals(Right(tNumberTriviaModel)));
          });

      test('should get a Failure when calling from remote data source unsuccesfully',
              () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenThrow(ServerException());

            final result = await repository.getConcreteNumberTrivia(tNumber);

            expect(result, equals(Left(ServerFailure())));
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          });

      test('should cache data when concrete call is succesful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
        await repository.getConcreteNumberTrivia(tNumber);
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    runTestsOffline(() {
      test('''should return CacheFailure when there is no cached data''', () async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    runTestsOnline(() {
      test(
          'should get a NumberTriviaModel when calling from remote data source succesfully',
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getRandomNumberTrivia();

            verify(mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTriviaModel)));
          });

      test('should cache data when remote call is succesful', () async {
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
          await repository.getRandomNumberTrivia();
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should get a Failure when calling from remote data source unsuccesfully',
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());

            final result = await repository.getRandomNumberTrivia();

            expect(result, equals(Left(ServerFailure())));
            verify(mockRemoteDataSource.getRandomNumberTrivia());
          });
    });
    runTestsOffline(() {
      test('''should return last locally cached data when data is present''', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });
      test(
          '''should return CacheFailure when device is offline and no cache data present''', () async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  test('should check if the device is online', () {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    repository.getConcreteNumberTrivia(tNumber);
    verify(mockNetworkInfo.isConnected);
  });
}
