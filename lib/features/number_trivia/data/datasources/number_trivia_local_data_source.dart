import 'dart:convert';

import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString == null) throw CacheException();
    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final jsonString = json.encode(triviaToCache.toJson());
    final result = await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
    if(result == false) throw CacheException();
    return Future.value(true);
  }
}
