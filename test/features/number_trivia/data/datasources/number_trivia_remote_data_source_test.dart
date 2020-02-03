import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_seed/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 404));
  }

  final tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'Test text');

  group('getConcreteNumberTrivia', () {
    test('''should perform a GET request on a URL 
  with number being the endpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTriviaModel when response is succesful', () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, tNumberTriviaModel);
    });

    test('should throw a ServerException when response is not succesful', () async {
      setUpMockHttpClientFailure404();
      final call = dataSource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    test('''should perform a GET request on a URL 
  with number being the enfpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();
      dataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTriviaModel when response is succesful', () async {
      setUpMockHttpClientSuccess200();
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, tNumberTriviaModel);
    });

    test('should throw a ServerException when response is not succesful', () async {
      setUpMockHttpClientFailure404();
      final call = dataSource.getRandomNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
