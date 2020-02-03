import 'dart:convert';

import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_seed/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

  group('getLastNumberTrivia', () {
    test('should get last trivia number when exists from shared preferences', () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });

    test('should throw CacheException when trivia number doesn´t exist', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    test('should call sharedPreferences to cache number trivia', () async {
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);

      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });

    test('should throw a CacheException when there is a caching value error', () async {
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => false);
      final call = dataSource.cacheNumberTrivia;
      expect(() => call(tNumberTriviaModel), throwsA(TypeMatcher<CacheException>()));
    });
  });
}
